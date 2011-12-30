//
//  EntityRequestNotification.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-30.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityReqNotificationData : NSObject

// The id of the request
@property (assign) NSInteger reqId;
// The id of the entity
@property (assign) NSInteger entityId;
// The type of entity
@property (assign) NSInteger entityType;
// The delay
@property (assign) NSTimeInterval reqDelay;

@end
