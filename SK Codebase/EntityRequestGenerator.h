//
//  DeviceRequestGenerator.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface EntityRequestGenerator : NSObject

// Gets the url for a syncrhonization request
+ (NSString *)getDeviceSynchronizeRequestPath:(SKEntity *) entity;

// Gets the url for an action request
+ (NSString *)getDeviceActionRequestPath:(SKEntity *) entity:(NSInteger) actionId:(NSInteger) dimLevel;

@end
