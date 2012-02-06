//
//  ImagePathHelper.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePathHelper.h"
#include "AppDelegate.h"
#include "Constants.h"
#include "StateHelper.h"

@implementation ImagePathHelper

// Gets the image name from an entity
+ (NSString *)getImageNameFromEntity:(SKEntity *)entity: (NSString *)prefix {
    if([entity isKindOfClass:[SKDevice class]]) {
        return [ImagePathHelper getImageNameFromDevice:(SKDevice *)entity
                                                      :prefix];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        return [ImagePathHelper getImageNameFromDeviceGroup:(SKDeviceGroup *)entity
                                                           :prefix];
    }
    
    return nil;
}

// Gets the image name from the device entity
+ (NSString *)getImageNameFromDevice:(SKDevice *)entity: (NSString *)prefix {
    switch (entity.CurrentStateID) {
        case DEVICE_STATE_ID__ON:
            if (entity.ModeID == DEVICE_MODE_ID__AUTO) {
                if (entity.CurrentDimLevel > 0 && entity.CurrentDimLevel < 100) {
                    prefix = [prefix stringByAppendingString:@"Dim"];
                } else {
                    prefix = [prefix stringByAppendingString:@"On"];
                }
                
                if ([entity.ModeType isEqualToString:DEVICE_MODE_TYPE__SCENARIO_DRIVEN]) {
                    prefix = [prefix stringByAppendingString:@"Scenario"];
                } else if ([entity.ModeType isEqualToString:DEVICE_MODE_TYPE__SCHEDULE_AND_RULE_DRIVEN]) {
                    prefix = [prefix stringByAppendingString:@"Rule"];
                }
            } else {
                // Get the app delegte
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                if ([appDelegate.entityStore getActiveScenarioId] == SCENARIO_ID__FROZEN || entity.InSemiAutoMode == false)
                    prefix = [prefix stringByAppendingString:@"OnFrozen"];
                else
                    prefix = [prefix stringByAppendingString:@"OnSemiAuto"];
            }
            break;
            
        case DEVICE_STATE_ID__OFF:
            prefix = [prefix stringByAppendingString:@"Off"];
            
            if (entity.ModeID == DEVICE_MODE_ID__AUTO) {
                if ([entity.ModeType isEqualToString:DEVICE_MODE_TYPE__SCENARIO_DRIVEN]) {
                    prefix = [prefix stringByAppendingString:@"Scenario"];
                } else if ([entity.ModeType isEqualToString:DEVICE_MODE_TYPE__SCHEDULE_AND_RULE_DRIVEN]) {
                    prefix = [prefix stringByAppendingString:@"Rule"];
                }
            } else {
                // Get the app delegte
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                if ([appDelegate.entityStore getActiveScenarioId ] == SCENARIO_ID__FROZEN || entity.InSemiAutoMode == false)
                    prefix = [prefix stringByAppendingString:@"Frozen"];
                else
                    prefix = [prefix stringByAppendingString:@"SemiAuto"];
            }

            break;
            
        default:
            prefix = @"DataSourceList_StatusWarning";
            break;
    }
    
    return [prefix stringByAppendingString:@".png"];
}

// Gets the image name from the device group entity
+ (NSString *)getImageNameFromDeviceGroup:(SKDeviceGroup *)entity: (NSString *)prefix {
    return [prefix stringByAppendingString:@"Group.png"];
}

// Gets the image name from the data source entity
+ (NSString *)getImageNameFromDataSource:(SKDataSource *)entity: (NSString *)prefix {
    NSInteger status = [StateHelper getPresentedStatus:entity];
    
    switch (status) {
        case DATA_SOURCE__PRESENTED_STATUS__GOOD:           
        {
            return [prefix stringByAppendingString:@"StatusOK.png"];
        }            
        case DATA_SOURCE__PRESENTED_STATUS__DEGRADED:
        {
            return [prefix stringByAppendingString:@"StatusWarning.png"];
        }            
        case DATA_SOURCE__PRESENTED_STATUS__BAD:
        {
            return [prefix stringByAppendingString:@"StatusError.png"];
        }            
        default:            
        {
            return [prefix stringByAppendingString:@"StatusWarning.png"];;
        }
    }
}

// Gets the image name from the data source group entity
+ (NSString *)getImageNameFromDataSourceGroup:(SKDataSourceGroup *)entity: (NSString *)prefix {
    return [prefix stringByAppendingString:@"Group.png"];    
}

// Gets the image name from the event entity
+ (NSString *)getImageNameFromEvent:(SKEvent *)entity: (NSString *)prefix {
    if([ENTITY_TYPE_STRING__SCENARIO isEqualToString:entity.EntityType]) {
        return [prefix stringByAppendingString:@"Scenario.png"];
    } else {
        if (entity.ActionId == ACTION_ID__TURN_ON) {
            if (entity.DimLevel > 0 && entity.DimLevel < 100) {
                prefix = [prefix stringByAppendingString:@"Dim"];
            } else {
                prefix = [prefix stringByAppendingString:@"On"];
            }            
        } else if(entity.ActionId == ACTION_ID__TURN_OFF) {
            prefix = [prefix stringByAppendingString:@"Off"];            
        }
    }
    
    return prefix;
}

@end
