//
//  RRule.m
//  recurrence-test
//
//  Created by Yi Yang on 7/6/15.
//  Copyright © 2015 Yi Yang. All rights reserved.
//

#import "RRule.h"

#define ALL_DATE_FLAGS NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear


@interface RRule ()

- (void)parseRRuleString:(NSString *)newRRuleString;
- (NSDate *)dateFromISO8601String:(NSString *)dateString;
@property (readonly) NSDateComponents *intervalComponents;

@end

@implementation RRule

static NSString * const rruleDictionaryType = @"kRRuleDictionary";
static NSString * const allowedFreqString[] = {
    @"YEARLY", @"MONTHLY", @"WEEKLY", @"DAILY", @"HOURLY", @"MINUTELY", @"SECONDLY"
};
static NSUInteger const allowedFreqTypes = 7;

@synthesize ruleComponents;
@synthesize timeZone;
@synthesize frequency;
@synthesize dateStart;
@synthesize until;
@synthesize count;
@synthesize interval;
@synthesize wkst;

- (instancetype)initWithDateComponents:(nonnull NSDateComponents *)newDateComponents frequency:(nonnull NSString *)newFrequency dateStart:(nullable NSDate *)newDateStart count:(nullable NSNumber *)newCount interval:(nullable NSNumber *)newInterval until:(nullable NSDate *)newUntil timeZone:(nullable NSTimeZone *)newTimeZone {
    if (self = [super init]) {
        ruleComponents = newDateComponents;
        timeZone       = newTimeZone ? newTimeZone : [NSTimeZone localTimeZone];
        frequency      = newFrequency;
        dateStart      = newDateStart;
        until          = newUntil;
        count          = newCount;
        interval       = newInterval ? newInterval : @1;
    }
    return self;
}

- (instancetype)initWithRRuleString:(nonnull NSString *)newRRuleString timezone:(nullable NSTimeZone *)newTimeZone {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    timeZone = newTimeZone ? newTimeZone : [NSTimeZone localTimeZone];

    [self parseRRuleString:newRRuleString];
    
    if (frequency == nil) {
        return nil;
    }
    
    if (interval == nil) {
        interval = @1;
    }

    return self;
}

- (instancetype)initWithDescription:(nonnull NSDictionary *)description {
    if ((!description[@"_type"]) ||
        (![description[@"_type"] isEqualToString:rruleDictionaryType]) ) {
        return nil;
    }
    return [self initWithRRuleString:description[@"rrule"]
                            timezone:[NSTimeZone timeZoneWithName:description[@"tzid"]]];
}

#pragma mark - setters and getters

- (NSString *)rruleString {
    return nil;
}

#pragma mark - object methods

- (NSDate *)nextRecurranceFromDate:(NSDate *)date notEqual:(BOOL)neq {
    NSDateComponents *intervalComponents = [self intervalComponents];
    NSCalendar *workingCal = [self workingCalendar];
    NSDate *referenceDate;
    NSDate *calcDate;
    NSDateComponents *dc;
    NSUInteger currentCount = 1, maxCount = count ? [count unsignedIntegerValue] : 0;

    if (dateStart) {
        if ([dateStart compare:date] == NSOrderedDescending) {
            referenceDate = dateStart.copy;
        } else if ([dateStart compare:date] == NSOrderedAscending && count != nil) {
            referenceDate = dateStart.copy;
        } else {
            referenceDate = date.copy;
        }
    } else {
        referenceDate = date.copy;
    }
    
    dc = [workingCal components:ALL_DATE_FLAGS fromDate:referenceDate];
    dc = [self matchesComponentsWithRuleComponents:dc];
    
    calcDate = [workingCal dateFromComponents:dc];
    if (calcDate == nil) {
        return nil;
    }
    
    // Adjustment for starting dates, since count matters for counts;
    while (maxCount && [calcDate compare:dateStart] == NSOrderedAscending) {
        calcDate = [workingCal dateByAddingComponents:intervalComponents toDate:calcDate options:0];
        if (calcDate == nil) {
            return nil;
        }

    }

    while (![self isCalcDateValid:calcDate withReferece:referenceDate notEqual:neq]) {
        calcDate = [workingCal dateByAddingComponents:intervalComponents toDate:calcDate options:0];
        if (calcDate == nil) {
            return nil;
        }

        if (maxCount) {
            currentCount += 1;
            if (currentCount > maxCount) {
                return nil;
            }
        }
        
        if (until) {
            if ([calcDate compare:until] == NSOrderedDescending) {
                return nil;
            }
        }
    }
    
    return calcDate;
}

- (BOOL)isCalcDateValid:(NSDate *)calcDate withReferece:(NSDate *)referenceDate notEqual:(BOOL)neq {
    if (neq) {
        return [calcDate compare:referenceDate] == NSOrderedDescending;
    } else {
        return [calcDate compare:referenceDate] != NSOrderedAscending;
    }
}

- (NSDateComponents *)matchesComponentsWithRuleComponents:(NSDateComponents *)calcComponents {
    if (ruleComponents.year != NSDateComponentUndefined) {
        calcComponents.year = ruleComponents.year;
    }
    
    if (ruleComponents.month != NSDateComponentUndefined) {
        calcComponents.month = ruleComponents.month;
    }
    
    if (ruleComponents.day != NSDateComponentUndefined) {
        calcComponents.day = ruleComponents.day;
    }
    
    if (ruleComponents.hour != NSDateComponentUndefined) {
        calcComponents.hour = ruleComponents.hour;
    }
    
    if (ruleComponents.minute != NSDateComponentUndefined) {
        calcComponents.minute = ruleComponents.minute;
    }
    
    if (ruleComponents.second != NSDateComponentUndefined) {
        calcComponents.second = ruleComponents.second;
    }
    
    if (ruleComponents.weekday != NSDateComponentUndefined) {
        calcComponents.weekday = ruleComponents.weekday;
    }
    
    if (ruleComponents.weekdayOrdinal != NSDateComponentUndefined) {
        calcComponents.weekdayOrdinal = ruleComponents.weekdayOrdinal;
    }

    if (ruleComponents.weekOfYear != NSDateComponentUndefined) {
        calcComponents.weekOfYear = ruleComponents.weekOfYear;
    }
    
    return calcComponents;
}

- (NSDateComponents *)intervalComponents {
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    if (interval == nil) {
        interval = @1;
    }
    
    if([frequency isEqualToString:@"SECONDLY"]){
        intervalComponents.second = [interval integerValue];
    }
    else if([frequency isEqualToString:@"MINUTELY"]){
        intervalComponents.minute = [interval integerValue];
    }
    else if([frequency isEqualToString:@"HOURLY"]){
        intervalComponents.hour = [interval integerValue];
    }
    else if([frequency isEqualToString:@"DAILY"]){
        intervalComponents.day = [interval integerValue];
    }
    else if([frequency isEqualToString:@"WEEKLY"]){
        intervalComponents.weekOfYear = [interval integerValue];
    }
    else if([frequency isEqualToString:@"MONTHLY"]){
        intervalComponents.month = [interval integerValue];
    }
    else if([frequency isEqualToString:@"YEARLY"]){
        intervalComponents.year = [interval integerValue];
    }
    
    return intervalComponents;
}

- (NSCalendar *)workingCalendar {
    NSCalendar *workingCalendar = [NSCalendar currentCalendar];
    [workingCalendar setTimeZone:timeZone];
    if (wkst) {
        [workingCalendar setFirstWeekday:[wkst unsignedIntegerValue]];
    }
    return workingCalendar;
}

- (NSDate *)nextRecurranceFromDate:(nonnull NSDate *)date {
    return [self nextRecurranceFromDate:date notEqual:YES];
}

- (NSDate *)nextRecurranceFromNow {
    return [self nextRecurranceFromDate:[NSDate date]];
}

- (NSDictionary *)description {
    return @{@"_type": rruleDictionaryType,
             @"rrule": self.rruleString,
             @"tzid":  self.timeZone.name};
}

#pragma mark - internal methods


- (void)parseRRuleString:(NSString *)newRRuleString {
    newRRuleString = [newRRuleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange rruleIndex = [newRRuleString rangeOfString:@"RRULE:"];
    if (rruleIndex.location != NSNotFound && rruleIndex.location == 0){
        newRRuleString =  [newRRuleString substringFromIndex:rruleIndex.length];
    }
    
    NSArray *rules = [newRRuleString componentsSeparatedByString:@";"];
    ruleComponents = [[NSDateComponents alloc] init];
    NSString *prevName;
    for (NSString *rule in rules) {
        if ([rule length] == 0) {
            continue;
        }
        
        NSArray *ruleKV = [rule componentsSeparatedByString:@"="];
        NSString *value = [ruleKV objectAtIndex:1];
        NSString *name  = [ruleKV objectAtIndex:0];
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        
        if (value == nil) {
            prevName = [name copy];
            continue;
        }
        
        if ([name isEqualToString:@"FREQ"]){
            NSArray *allowedFreq = [[NSArray alloc] initWithObjects:allowedFreqString
                                                              count:allowedFreqTypes];
            if ([allowedFreq containsObject:value]) {
                frequency = value;
            } else {
                NSLog(@"Invalid FREQ for RRule, this property is required.");
                return;
            }
        }
        else if ([name isEqualToString:@"UNTIL"] || [prevName isEqualToString:@"UNTIL"]){
            until = [self dateFromISO8601String:value];
        }
        else if ([name isEqualToString:@"DTSTART"] || [prevName isEqualToString:@"DTSTART"]) {
            dateStart = [self dateFromISO8601String:value];
        }
        else if ([name isEqualToString:@"COUNT"]) {
            count = [nf numberFromString:value];
        }
        else if ([name isEqualToString:@"INTERVAL"]) {
            interval = [nf numberFromString:value];
        }
        else if ([name isEqualToString:@"BYSECOND"]) {
            ruleComponents.second = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYMINUTE"]) {
            ruleComponents.minute = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYHOUR"]) {
            ruleComponents.hour = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYDAY"]) {
            NSDictionary *weekdayMap = @{@"SU": @1,
                                         @"MO": @2,
                                         @"TU": @3,
                                         @"WE": @4,
                                         @"TH": @5,
                                         @"FR": @6,
                                         @"SA": @7};
            
            NSString *weekday = [value componentsSeparatedByString:@","].firstObject;
            NSNumber *weekdayNum = [weekdayMap objectForKey:weekday];
            if (weekdayNum != nil) {
                ruleComponents.weekday = [weekdayNum integerValue];
            }
        }
        else if ([name isEqualToString:@"BYMONTHDAY"]) {
            ruleComponents.day = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYYEARDAY"]) {
            // Not supported
        }
        else if ([name isEqualToString:@"BYWEEKNO"]) {
            ruleComponents.weekOfYear = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYMONTH"]) {
            ruleComponents.month = [[value componentsSeparatedByString:@","].firstObject integerValue];
        }
        else if ([name isEqualToString:@"BYSETPOS"]) {
            // Not supported
        }
        else if ([name isEqualToString:@"WKST"]) {
            NSDictionary *weekdayMap = @{@"SU": @1,
                                         @"MO": @2,
                                         @"TU": @3,
                                         @"WE": @4,
                                         @"TH": @5,
                                         @"FR": @6,
                                         @"SA": @7};
            NSNumber *weekdayNum = [weekdayMap objectForKey:value];
            if (weekdayNum != nil) {
                wkst = weekdayNum;
            }
        }
    }
}

- (NSDate *)dateFromISO8601String:(NSString *)dateString {
    if ([dateString containsString:@":"]) {
        dateString = [[dateString componentsSeparatedByString:@":"] objectAtIndex:1];
    }
    
    NSString* format;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([dateString length] == 8) {
        format = @"yyyyMMdd";
    } else if ([dateString length] == 15) {
        format = @"yyyyMMdd'T'HHmmss";
    } else if ([dateString length] == 16) {
        format = @"yyyyMMdd'T'HHmmss'Z'";
    } else {
        return nil;
    }
    [formatter setDateFormat:format];
    
    if ([dateString hasSuffix:@"Z"]) {
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    } else {
        [formatter setTimeZone:timeZone];
    }
    
    return [formatter dateFromString:dateString];
}


@end
