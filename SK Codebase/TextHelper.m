//
//  TextHelper.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextHelper.h"
#import "StateHelper.h"
#include "Constants.h"

@implementation TextHelper

// Gets the info text for a specific device
+ (NSString *)getDeviceInfoText:(SKDevice *)entity {
    NSString *localized;
    
    if (entity.CurrentStateID == DEVICE_STATE_ID__OFF) {
        localized = NSLocalizedStringFromTable(@"Off", @"Texts", nil);
    } else if (entity.CurrentStateID == DEVICE_STATE_ID__ON) {
        if (entity.CurrentDimLevel == 100 || entity.CurrentDimLevel == 0 || entity.CurrentDimLevel == -1) {
            localized = NSLocalizedStringFromTable(@"On", @"Texts", nil);
        } else {
            localized = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Dimmed %i%%", @"Texts", nil), entity.CurrentDimLevel];
        }
    } else
        localized = NSLocalizedStringFromTable(@"On", @"Texts", nil);
    
    return localized;
}

// Gets the info text for a specific device group
+ (NSString *)getDeviceGroupInfoText:(SKDeviceGroup *)entity {
    NSString *localized = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%i devices", @"Texts", nil), entity.devices.count];
    
    return localized;
}

// Gets the value text for a specific data source
+ (NSString *)getDataSourceValueText:(SKDataSource *)entity {
    if(entity.UsedValue == nil || [entity.UsedValue isEqualToString:@""]) {
        return NSLocalizedStringFromTable(@"No value", @"Texts", nil);
    }
    
    NSString *valueToDisplay = entity.UsedValue;
    
    if(entity.EngineeringUnit == nil || [entity.EngineeringUnit isEqualToString:@""]) {
        return valueToDisplay;
    } else {
        return [NSString stringWithFormat:@"%@ %@", valueToDisplay, entity.EngineeringUnit];
    }
}

// Gets the formatted status text for a specific data source
+ (NSString *)getFormattedDataSourceStatusText:(SKDataSource *)entity {
    NSInteger presentedStatus = [StateHelper getPresentedStatus:entity];
    
    switch (presentedStatus) {
        case DATA_SOURCE__PRESENTED_STATUS__GOOD:
        {
            return NSLocalizedStringFromTable(@"Good, valid value", @"Texts", nil);
            break;
        }
            
        case DATA_SOURCE__PRESENTED_STATUS__DEGRADED:
        {
            return NSLocalizedStringFromTable(@"Degraded", @"Texts", nil);
            break;
        }
            
        case DATA_SOURCE__PRESENTED_STATUS__BAD:
        {
            return NSLocalizedStringFromTable(@"Bad, invalid value", @"Texts", nil);
            break;
        }
            
        default:
            
        {
            return NSLocalizedStringFromTable(@"Unknown status", @"Texts", nil);
            break;        
        }            
    }
}

// Gets the info text for a specific data source group
+ (NSString *)getDataSourceGroupInfoText:(SKDataSourceGroup *)entity {
    NSString *localized = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%i data sources", @"Texts", nil), entity.dataSources.count];
    
    return localized; 
}

// Gets the formatted date text, simplified
+ (NSString *)getFormattedDateText:(NSString *)dateText:(Boolean)includeSeconds {
    NSString *result;
    
    if (dateText.length > 19) {
        dateText = [dateText substringToIndex:19];
    }
    
    NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:defaultTimeZone];

    NSDate *parsed = [dateFormatter dateFromString:dateText];
	NSDate *today = [[NSDate alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    [cal setTimeZone:defaultTimeZone];
    
    NSDateComponents *todayComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:today];
    NSDateComponents *compareComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:parsed];
    
    NSInteger dayToday = [todayComponents day];    
    NSInteger monthToday = [todayComponents month];
    NSInteger yearToday = [todayComponents year];
    
    NSInteger dayParsed = [compareComponents day];    
    NSInteger monthParsed = [compareComponents month];
    NSInteger yearParsed = [compareComponents year];
    
    if(
       dayToday == dayParsed &&
       monthToday == monthParsed &&
       yearToday == yearParsed) {
        if(includeSeconds)
            [dateFormatter setDateFormat:@"HH:mm:ss"];
        else
            [dateFormatter setDateFormat:@"HH:mm"];
        // Set the result...
        result = [dateFormatter stringFromDate:parsed];
        
        return result;
    } else {
        NSDate *tomorrow = [NSDate dateWithTimeInterval:60*60*24 sinceDate:today];
        NSDate *yesterday = [NSDate dateWithTimeInterval:-(60*60*24) sinceDate:today];
        
        // Tomorrow...
        compareComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tomorrow];
        
        NSInteger dayCompared = [compareComponents day];    
        NSInteger monthCompared = [compareComponents month];
        NSInteger yearCompared = [compareComponents year];
        
        if(
           dayParsed == dayCompared &&
           monthParsed == monthCompared &&
           yearParsed == yearCompared) {
            // Tomorrow...
            
            // Change the date format
            if(includeSeconds)
                [dateFormatter setDateFormat:@"HH:mm:ss"];
            else
                [dateFormatter setDateFormat:@"HH:mm"];
            // Get the lozalized message
            NSString *localized = NSLocalizedStringFromTable(@"Tomorrow, %@", @"Texts", nil);            
            // Set the result...
            result = [NSString stringWithFormat:localized, [dateFormatter stringFromDate:parsed]];
            
            return result;
        }
        
        // Yesterday...
        compareComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:yesterday];
        
        dayCompared = [compareComponents day];    
        monthCompared = [compareComponents month];
        yearCompared = [compareComponents year];
        
        if(
           dayParsed == dayCompared &&
           monthParsed == monthCompared &&
           yearParsed == yearCompared) {
            // Yesterday...
            
            // Change the date format
            if(includeSeconds)
                [dateFormatter setDateFormat:@"HH:mm:ss"];
            else
                [dateFormatter setDateFormat:@"HH:mm"];
            // Get the lozalized message
            NSString *localized = NSLocalizedStringFromTable(@"Yesterday, %@", @"Texts", nil);            
            // Set the result...
            result = [NSString stringWithFormat:localized, [dateFormatter stringFromDate:parsed]];
            
            return result;
        }
        
        if(includeSeconds)
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        else
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:parsed];
        
        return result;
    }
}

// Gets the info text for a specific event
+ (NSString *)getEventInfoText:(SKEvent *)entity {
    NSString *localized;
    
    if([entity.EntityType isEqualToString:ENTITY_TYPE_STRING__SCENARIO]) {
        return @"NO SUPPORT";
    } else {
        if(entity.ActionId == ACTION_ID__TURN_ON) {
            if(entity.DimLevel > 0 && entity.DimLevel < 100) {
                return [NSString stringWithFormat:NSLocalizedStringFromTable(@"Dim %i%%", @"Texts", nil), entity.DimLevel];
            } else {
                return NSLocalizedStringFromTable(@"On", @"Texts", nil);
            }
        } else {
            return NSLocalizedStringFromTable(@"Off", @"Texts", nil);
        }
    }
    
    return localized;   
}

// Parses a date string and flags the date as future or historic
+ (Boolean)isFutureDate:(NSString *)dateString {
    NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:defaultTimeZone];
    
    NSDate *parsed = [dateFormatter dateFromString:dateString];
	NSDate *today = [[NSDate alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    [cal setTimeZone:defaultTimeZone];

    NSTimeInterval time = [parsed timeIntervalSinceDate:today];
    
    return time > 0;
}

@end
