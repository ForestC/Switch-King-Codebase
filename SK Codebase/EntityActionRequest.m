//
//  EntityActionRequest.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityActionRequest.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKDataSource.h"
#include "Constants.h"

@implementation EntityActionRequest


- (EntityReqNotificationData *)toNotificationData {
    EntityReqNotificationData *data = [[EntityReqNotificationData alloc] init];
    
    data.entityId = self.entity.ID;
    
    if([self.entity isKindOfClass:[SKDevice class]]) {
        data.entityType = ENTITY_TYPE__DEVICE;
    } else if([self.entity isKindOfClass:[SKDeviceGroup class]]) {
        data.entityType = ENTITY_TYPE__DEVICE_GROUP;
    } if([self.entity isKindOfClass:[SKDataSource class]]) {
        data.entityType = ENTITY_TYPE__DATA_SOURCE;
    }
    
    return data;
}    

@synthesize dimLevel;
@synthesize entity;
@synthesize actionId;

@end
