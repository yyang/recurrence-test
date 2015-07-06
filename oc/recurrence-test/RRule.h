//
//  RRule.h
//  recurrence-test
//
//  Created by Yi Yang on 7/6/15.
//  Copyright © 2015 Yi Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Note: RRule is not fully supported, each rule supports only one item now, and the following are 
 * not supported:
 * WKST, BYYEARDAY, BYSETPOS
 * We may further refer this scheduler to build a better one:
 * https://github.com/FabienDiTore/ios-rrule_parser/blob/master/RruleParser/Scheduler.m
 */

NS_ASSUME_NONNULL_BEGIN
@interface RRule : NSObject

@property NSDateComponents *ruleComponents;
@property NSTimeZone *timeZone;
@property NSString *frequency;
@property NSDate *dateStart;
@property NSDate *until;
@property NSNumber *wkst;
@property NSNumber *count;
@property NSNumber *interval;
@property (readonly) NSString *rruleString;

- (instancetype)initWithDateComponents:(NSDateComponents *)dateComponents frequency:(nonnull NSString *)frequency dateStart:(nullable NSDate *)dateStart count:(nullable NSNumber *)count interval:(nullable NSNumber *)interval until:(nullable NSDate *)until timeZone:(nullable NSTimeZone *)timezone;
- (instancetype)initWithRRuleString:(NSString *)rruleString timezone:(nullable NSTimeZone *)timezone;
- (instancetype)initWithDescription:(NSDictionary *)description;

- (NSDate *)nextRecurranceFromDate:(NSDate *)date notEqual:(BOOL)neq;
- (NSDate *)nextRecurranceFromDate:(NSDate *)date;
- (NSDate *)nextRecurranceFromNow;

- (NSDictionary *)description;

@end
NS_ASSUME_NONNULL_END
