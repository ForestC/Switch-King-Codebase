//
//  TextHelper.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKEvent.h"
#import "SKDataSource.h"
#import "SKDataSourceGroup.h"

@interface TextHelper : NSObject

// Gets the info text for a specific device
+ (NSString *)getDeviceInfoText:(SKDevice *)entity;

// Gets the info text for a specific device group
+ (NSString *)getDeviceGroupInfoText:(SKDeviceGroup *)entity;

// Gets the value text for a specific data source
+ (NSString *)getDataSourceValueText:(SKDataSource *)entity;

// Gets the info text for a specific data source group
+ (NSString *)getDataSourceGroupInfoText:(SKDataSourceGroup *)entity;

// Gets the formatted status text for a specific data source
+ (NSString *)getFormattedDataSourceStatusText:(SKDataSource *)entity;

// Gets the formatted date text, simplified
+ (NSString *)getFormattedDateText:(NSString *)dateText:(Boolean)includeSeconds;

// Gets the info text for a specific event
+ (NSString *)getEventInfoText:(SKEvent *)entity;

// Parses a date string
+ (NSDate *)parseRFC3339Date:(NSString *)dateString;

// Parses a date string and flags the date as future or historic
+ (Boolean)isFutureDate:(NSString *)dateString;

@end
