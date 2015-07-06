//
//  NSDateComponents+Serialize.m
//  HomeOne
//
//  Created by Yi Yang on 2/28/15.
//  Copyright (c) 2015 Yi Yang. All rights reserved.
//

#import "NSDateComponents+Serialize.h"

@implementation NSDateComponents (Serialize)

static NSString* const datecComponentDictionaryType = @"kDateComponentsDictionary";
static NSString* const rfc2445DictionaryType = @"kRFC2445Dictionary";

+ (NSDateComponents *)dateComponentsWithDictionary:(NSDictionary *)dictionary {
    if ((!dictionary[@"_type"]) ||
        (![dictionary[@"_type"] isEqualToString:datecComponentDictionaryType]) ) {
        return nil;
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    if (dictionary[@"era"]) {
        dateComponents.era = [dictionary[@"era"] integerValue];
    }
    
    if (dictionary[@"year"]) {
        dateComponents.year = [dictionary[@"year"] integerValue];
    }
    
    if (dictionary[@"month"]) {
        dateComponents.month = [dictionary[@"month"] integerValue];
    }
    
    if (dictionary[@"day"]) {
        dateComponents.day = [dictionary[@"day"] integerValue];
    }
    
    if (dictionary[@"hour"]) {
        dateComponents.hour = [dictionary[@"hour"] integerValue];
    }
    
    if (dictionary[@"minute"]) {
        dateComponents.minute = [dictionary[@"minute"] integerValue];
    }
    
    if (dictionary[@"second"]) {
        dateComponents.second = [dictionary[@"second"] integerValue];
    }
    
    if (dictionary[@"nanosecond"]) {
        dateComponents.nanosecond = [dictionary[@"nanosecond"] integerValue];
    }
    
    if (dictionary[@"weekday"]) {
        dateComponents.weekday = [dictionary[@"weekday"] integerValue];
    }
    
    if (dictionary[@"weekdayOrdinal"]) {
        dateComponents.weekdayOrdinal = [dictionary[@"weekdayOrdinal"] integerValue];
    }
    
    if (dictionary[@"quarter"]) {
        dateComponents.quarter = [dictionary[@"quarter"] integerValue];
    }
    
    if (dictionary[@"weekOfMonth"]) {
        dateComponents.weekOfMonth = [dictionary[@"weekOfMonth"] integerValue];
    }
    
    if (dictionary[@"weekOfYear"]) {
        dateComponents.weekOfYear = [dictionary[@"weekOfYear"] integerValue];
    }
    
    if (dictionary[@"leapMonth"]) {
        dateComponents.leapMonth = [dictionary[@"leapMonth"] boolValue];
    }
    
    return dateComponents;
}

- (NSDictionary *)dateComponentsDictionary {
    NSMutableDictionary *dictionary = @{@"_type": datecComponentDictionaryType}.mutableCopy;
    
    if (self.era != NSDateComponentUndefined) {
        dictionary[@"era"] = @(self.era);
    }
    
    if (self.year != NSDateComponentUndefined) {
        dictionary[@"year"] = @(self.year);
    }
    
    if (self.month != NSDateComponentUndefined) {
        dictionary[@"month"] = @(self.month);
    }
    
    if (self.day != NSDateComponentUndefined) {
        dictionary[@"day"] = @(self.day);
    }
    
    if (self.hour != NSDateComponentUndefined) {
        dictionary[@"hour"] = @(self.hour);
    }
    
    if (self.minute != NSDateComponentUndefined) {
        dictionary[@"minute"] = @(self.minute);
    }
    
    if (self.second != NSDateComponentUndefined) {
        dictionary[@"second"] = @(self.second);
    }
    
    if (self.nanosecond != NSDateComponentUndefined) {
        dictionary[@"nanosecond"] = @(self.nanosecond);
    }
    
    if (self.weekday != NSDateComponentUndefined) {
        dictionary[@"weekday"] = @(self.weekday);
    }
    
    if (self.weekdayOrdinal != NSDateComponentUndefined) {
        dictionary[@"weekdayOrdinal"] = @(self.weekdayOrdinal);
    }
    
    if (self.quarter != NSDateComponentUndefined) {
        dictionary[@"quarter"] = @(self.quarter);
    }
    
    if (self.weekOfMonth != NSDateComponentUndefined) {
        dictionary[@"weekOfMonth"] = @(self.weekOfMonth);
    }
    
    if (self.weekOfYear != NSDateComponentUndefined) {
        dictionary[@"weekOfYear"] = @(self.weekOfYear);
    }
    
    if (@YES) { // It should always be no
        dictionary[@"leapMonth"] = @(self.leapMonth);
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (NSDateComponents *)dateComponentsFromRFC2445:(NSDictionary *)description {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    if (description[@"BYWEEKNO"]) {
        NSInteger weekOfYear = [self firstIntValueFromRCF2445Object:description[@"BYWEEKNO"]];
        dateComponents.weekOfYear = weekOfYear;
    }
    
    if (description[@"BYMONTH"]) {
        NSInteger month = [self firstIntValueFromRCF2445Object:description[@"BYMONTH"]];
        if (month > 0) {
            dateComponents.month = month;
        }
    }
    
    if (description[@"BYMONTHDAY"]) {
        NSInteger day = [self firstIntValueFromRCF2445Object:description[@"BYMONTHDAY"]];
        if (day > 0) {
            dateComponents.day = day;
        }
    }
    
    if (description[@"BYDAY"]) {
        NSDictionary *weekdayMap = @{@"SU": @1,
                                     @"MO": @2,
                                     @"TU": @3,
                                     @"WE": @4,
                                     @"TH": @5,
                                     @"FR": @6,
                                     @"SA": @7};
        
        NSString *weekday = [description[@"BYDAY"] componentsSeparatedByString:@","].firstObject;
        NSNumber *weekdayNum = [weekdayMap objectForKey:weekday];
        if (weekdayNum != nil) {
            dateComponents.weekday = [weekdayNum integerValue];
        }
    }
    
    if (description[@"BYHOUR"]) {
        NSInteger hour = [self firstIntValueFromRCF2445Object:description[@"BYHOUR"]];
        dateComponents.hour = hour;
    }
    
    if (description[@"BYMINUTE"]) {
        NSInteger minute = [self firstIntValueFromRCF2445Object:description[@"BYMINUTE"]];
        dateComponents.minute = minute;
    }
    
    if (description[@"BYSECOND"]) {
        NSInteger second = [self firstIntValueFromRCF2445Object:description[@"BYSECOND"]];
        dateComponents.second = second;
    }
    
    
    return dateComponents;
}

- (NSDictionary *)RFC2445Description {
    NSString *freq = [self RFC2445Freq];
    if (freq == nil) {
        return nil;
    }
    NSMutableDictionary *description = @{@"_type": rfc2445DictionaryType,
                                         @"FREQ": freq}.mutableCopy;
    
    if (self.month != NSDateComponentUndefined) {
        description[@"BYMONTH"] = @(self.month);
    }
    
    if (self.day != NSDateComponentUndefined) {
        description[@"BYMONTHDAY"] = @(self.day);
    }
    
    if (self.hour != NSDateComponentUndefined) {
        description[@"BYHOUR"] = @(self.hour);
    }
    
    if (self.minute != NSDateComponentUndefined) {
        description[@"BYMINUTE"] = @(self.minute);
    }
    
    if (self.second != NSDateComponentUndefined) {
        description[@"BYSECOND"] = @(self.second);
    }
    
    if (self.weekday != NSDateComponentUndefined) {
        switch (self.weekday) {
            case 1: description[@"BYDAY"] = @"SU"; break;
            case 2: description[@"BYDAY"] = @"MO"; break;
            case 3: description[@"BYDAY"] = @"TU"; break;
            case 4: description[@"BYDAY"] = @"WE"; break;
            case 5: description[@"BYDAY"] = @"TH"; break;
            case 6: description[@"BYDAY"] = @"FR"; break;
            case 7: description[@"BYDAY"] = @"SA"; break;
        }
    }
    
    if (self.weekOfYear != NSDateComponentUndefined) {
        description[@"BYWEEKNO"] = @(self.weekOfYear);
    }
    
    return [NSDictionary dictionaryWithDictionary:description];
}

- (NSString *)RFC2445Freq {
    if (self.year != NSDateComponentUndefined ||
        self.era != NSDateComponentUndefined) {
        return nil;
    }
    
    if (self.month != NSDateComponentUndefined ||
        self.weekOfYear != NSDateComponentUndefined) {
        return @"YEARLY";
    }
    
    if (self.day != NSDateComponentUndefined ||
        self.weekdayOrdinal != NSDateComponentUndefined ||
        self.weekOfMonth != NSDateComponentUndefined) {
        return @"MONTHLY";
    }
    
    if (self.weekday != NSDateComponentUndefined) {
        return @"WEEKLY";
    }
    
    if (self.hour != NSDateComponentUndefined) {
        return @"DAILY";
    }
    
    if (self.minute != NSDateComponentUndefined) {
        return @"HOURLY";
    }
    
    if (self.second != NSDateComponentUndefined) {
        return @"MINUTELY";
    }
    
    if (self.nanosecond != NSDateComponentUndefined) {
        return @"SECONDLY";
    }
    
    return nil;
}

+ (NSInteger)firstIntValueFromRCF2445Object:(id)object {
    if ([object isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)object integerValue];
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        NSArray *components      = [(NSString *)object componentsSeparatedByString:@","];
        NSString *firstComponent = [components firstObject];
        return [firstComponent integerValue];
    }
    
    return 0;
}

@end
