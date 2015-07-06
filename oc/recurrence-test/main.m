//
//  main.m
//  recurrence-test
//
//  Created by Yi Yang on 7/6/15.
//  Copyright © 2015 Yi Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateComponents+Serialize.h"
#import "RRule.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *timezone = @"America/Los_Angeles";
        NSString *rfcString = @"DTSTART=20150616T103000Z;FREQ=DAILY;BYHOUR=10;BYMINUTE=30;BYSECOND=0;UNTIL=20150712T153000Z";
        
        RRule *rule = [[RRule alloc] initWithRRuleString:rfcString timezone:[NSTimeZone timeZoneWithName:timezone]];

        NSLog(@"%@", [rule nextRecurranceFromNow]);
    }
    return 0;
}
