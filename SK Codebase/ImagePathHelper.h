//
//  ImagePathHelper.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"

@interface ImagePathHelper : NSObject

// Gets the image name from an entity
+ (NSString *)getImageNameFromEntity:(SKEntity *)entity: (NSString *)prefix;
// Gets the image name from the device entity
+ (NSString *)getImageNameFromDevice:(SKDevice *)entity: (NSString *)prefix;
// Gets the image name from the device group entity
+ (NSString *)getImageNameFromDeviceGroup:(SKDeviceGroup *)entity: (NSString *)prefix;

@end
