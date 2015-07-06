//
//  NSDateComponents+Serialize.h
//  HomeOne
//
//  Created by Yi Yang on 2/28/15.
//  Copyright (c) 2015 Yi Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateComponents (Serialize)

+ (NSDateComponents *)dateComponentsWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dateComponentsDictionary;

// Note on RFC 2445 Conversion:
// Since NSDateComponent is not directly compatible with RCF 2445, we are only converting most
// necessary elements. Thus may provide different recurrence during conversion.
//
// The safe elements are:
// month, day, hour, minute, second, weekday, weekOfyear
// (only the first item in list will be converted)
//
// Those items are supported by NSDateComponent but not supported by RCF 2445:
// era, year, nanosecond, weekdayOrdinal, quarter, weekOfMonth
//
// Those items are supported by RCF 2445 but not supported by NSDateComponent:
// UNTIL, COUNT, INTERVAL, BYYEARDAY, BYSETPOS, WKST

+ (NSDateComponents *)dateComponentsFromRFC2445:(NSDictionary *)description;
- (NSDictionary *)RFC2445Description;

@end
