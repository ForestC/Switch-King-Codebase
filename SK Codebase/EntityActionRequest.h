//
//  EntityActionRequest.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"
#import "EntityHttpReqNotificationData.h"
#import "SKDevice.h"

@interface EntityActionRequest : NSObject

// Creates a device action request for a device by using the supplied params
+ (EntityActionRequest *)createByDeviceAction:(SKDevice *)device:(NSInteger) actionId:(NSInteger) dimLevel:(NSTimeInterval) delay;

- (EntityHttpReqNotificationData *)toNotificationData;

// The entity involved in the request
@property (retain) SKEntity * entity;
// The requested action
@property (assign) NSInteger actionId;
// The requested dim level
@property (assign) NSInteger dimLevel;
// The requested delay prior to performing the action
@property (assign) NSTimeInterval reqActionDelay;

@end
