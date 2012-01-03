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
        localized = NSLocalizedString(@"Off", @"Texts");
    } else if (entity.CurrentStateID == DEVICE_STATE_ID__ON) {
        if (entity.CurrentDimLevel == 100 || entity.CurrentDimLevel == 0 || entity.CurrentDimLevel == -1) {
            localized = NSLocalizedString(@"On", @"Texts");
        } else {
            localized = [NSString stringWithFormat:NSLocalizedString(@"Dimmed %i%", @"Texts"), entity.CurrentDimLevel];
        }
    } else
        localized = NSLocalizedString(@"On", @"Texts");
    
    return localized;
}

@end
