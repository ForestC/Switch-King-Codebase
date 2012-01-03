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

@interface TextHelper : NSObject

// Gets the info text for a specific device
+ (NSString *)getDeviceInfoText:(SKDevice *)entity;

@end
