//
//  DeviceRequestGenerator.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityRequestGenerator.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKDataSource.h"
#import "Constants.h"

@implementation EntityRequestGenerator

// Gets the url for a syncrhonization request
+ (NSString *)getDeviceSynchronizeRequestPath:(SKEntity *) entity {
    NSString *url;
    
    if([entity isKindOfClass:[SKDevice class]]) {
        url = [NSString stringWithFormat:@"devices/%d/synchronize", entity.ID];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        url = [NSString stringWithFormat:@"devicegroups/%d/synchronize", entity.ID];
    } else {
        NSLog(@"Invalid type for synchronization request.");
    }
    
    return url;
}

// Gets the url for an action request
+ (NSString *)getDeviceActionRequestPath:(SKEntity *) entity:(NSInteger) actionId:(NSInteger) dimLevel {
    NSString *url;
    
    if([entity isKindOfClass:[SKDevice class]]) {
        switch (actionId) {
            case ACTION_ID__TURN_ON:
                if(dimLevel > 0 && dimLevel < 100)
                    url = [NSString stringWithFormat:@"/devices/%d/dim/%d", entity.ID, dimLevel];
                else
                    url = [NSString stringWithFormat:@"/devices/%d/turnon", entity.ID];
                break;
            case ACTION_ID__TURN_OFF:
                url = [NSString stringWithFormat:@"/devices/%d/turnoff", entity.ID];
                break;
            default:
                NSLog(@"Invalid type of action.");
                break;
        }
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        switch (actionId) {
            case ACTION_ID__TURN_ON:
                if(dimLevel > 0 && dimLevel < 100)
                    url = [NSString stringWithFormat:@"/devicegroups/%d/dim/%d", entity.ID, dimLevel];
                else
                    url = [NSString stringWithFormat:@"/devicegroups/%d/turnon", entity.ID];
                break;
            case ACTION_ID__TURN_OFF:
                url = [NSString stringWithFormat:@"/devicegroups/%d/turnoff", entity.ID];
                break;
            default:
                NSLog(@"Invalid type of action.");
                break;
        }     
    } else {
        NSLog(@"Invalid type for synchronization request.");
    }
    
    return url;
}

@end
