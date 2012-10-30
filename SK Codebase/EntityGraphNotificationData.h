//
//  EntityGraphNotificationData.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>

@interface EntityGraphNotificationData : NSObject

// The id of the request
@property (assign) NSInteger reqId;
// The id of the entity
@property (assign) NSInteger entityId;
// The type of entity
@property (assign) NSInteger entityType;

@end
