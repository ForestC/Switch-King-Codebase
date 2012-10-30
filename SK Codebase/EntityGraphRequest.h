//
//  EntityGraphRequest.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"
#import "SKDataSource.h"
#import "EntityGraphNotificationData.h"

@interface EntityGraphRequest : NSObject

// Creates a device action request for a device by using the supplied params
+ (EntityGraphRequest *)createByDataSource:(SKDataSource *)dataSource:(CGSize) graphSize:(NSInteger) minutesBack;

- (EntityGraphNotificationData *)toNotificationData;

// The entity involved in the request
@property (retain) SKEntity *entity;
// The requested size
@property (assign) CGSize graphSize;
// The requested history
@property (assign) NSInteger minutesBack;

@end