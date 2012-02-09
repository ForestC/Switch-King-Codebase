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
#import "SKScenario.h"
#import "SKEvent.h"
#include "Constants.h"

@implementation EntityActionRequest

@synthesize dimLevel;
@synthesize entity;
@synthesize actionId;
@synthesize reqActionDelay;

// Creates a device action request for a device by using the supplied params
+ (EntityActionRequest *)createByDeviceAction:(SKDevice *)device:(NSInteger) actionId:(NSInteger) dimLevel:(NSTimeInterval) delay {
    
    EntityActionRequest *r = [EntityActionRequest alloc];
    
    r.actionId = actionId;
    r.dimLevel = dimLevel;
    r.entity = device;
    r.reqActionDelay = delay;
    
    return r;
}

- (EntityHttpReqNotificationData *)toNotificationData {
    EntityHttpReqNotificationData *data = [[EntityHttpReqNotificationData alloc] init];
    
    data.entityId = self.entity.ID;
    data.reqDelay = self.reqActionDelay;
    
    if([self.entity isKindOfClass:[SKDevice class]]) {
        data.entityType = ENTITY_TYPE__DEVICE;
    } else if([self.entity isKindOfClass:[SKDeviceGroup class]]) {
        data.entityType = ENTITY_TYPE__DEVICE_GROUP;
    } else if([self.entity isKindOfClass:[SKDataSource class]]) {
        data.entityType = ENTITY_TYPE__DATA_SOURCE;
    } else if([self.entity isKindOfClass:[SKScenario class]]) {
        data.entityType = ENTITY_TYPE__SCENARIO;
    } else if([self.entity isKindOfClass:[SKEvent class]]) {
        data.entityType = ENTITY_TYPE__EVENTS;
    }
    
    return data;
}    

@end
