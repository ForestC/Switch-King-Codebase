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
#import "SKDataSource.h"
#import "SKDataSourceGroup.h"
#import "SKEvent.h"

@interface ImagePathHelper : NSObject

// Gets the image name from an entity
+ (NSString *)getImageNameFromEntity:(SKEntity *)entity: (NSString *)prefix;
// Gets the image name from the device entity
+ (NSString *)getImageNameFromDevice:(SKDevice *)entity: (NSString *)prefix;
// Gets the image name from the device group entity
+ (NSString *)getImageNameFromDeviceGroup:(SKDeviceGroup *)entity: (NSString *)prefix;
// Gets the image name from the data source entity
+ (NSString *)getImageNameFromDataSource:(SKDataSource *)entity: (NSString *)prefix;
// Gets the image name from the data source group entity
+ (NSString *)getImageNameFromDataSourceGroup:(SKDataSourceGroup *)entity: (NSString *)prefix;
// Gets the image name from the event entity
+ (NSString *)getImageNameFromEvent:(SKEvent *)entity: (NSString *)prefix;



@end
