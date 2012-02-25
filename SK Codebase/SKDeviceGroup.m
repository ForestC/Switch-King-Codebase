//
//  SKDeviceGroup.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDeviceGroup.h"
#import "Constants.h"
#import "SKDevice.h"

@implementation SKDeviceGroup

@synthesize devices;

// Indicates whether at least one device in this group supports absolute dim
- (Boolean)supportsAbsoluteDim {
    NSInteger supportsDim = 0;
            
    for (NSUInteger i = 0; i < devices.count; ++i) {
        if([((SKDevice *)[devices objectAtIndex:i]).SupportsAbsoluteDimLvl  isEqualToString:XML_VALUE__TRUE]) {
            supportsDim++;
            break;
        }
    }
    
    if(supportsDim > 0)
        return true;
    else
        return false;
}

@end
