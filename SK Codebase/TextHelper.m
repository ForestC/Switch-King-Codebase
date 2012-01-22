//
//  TextHelper.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextHelper.h"
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

@end
