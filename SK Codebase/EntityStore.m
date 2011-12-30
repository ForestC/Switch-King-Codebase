//
//  EntityStore.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"
#import "SKEntity.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKDataSource.h"
#import "DeviceListViewController.h"
#import "EntityReqNotificationData.h"
#include "Constants.h"

@implementation EntityStore
{
    NSMutableArray *deviceList;
    NSMutableArray *deviceDirtyList;    
}

@synthesize deviceListViewController;

- (EntityStore *)init {
    self = [super init];
    
    deviceDirtyList = [[NSMutableArray alloc] initWithCapacity:50];
    
    [self addEntityObservers];
    
    return self;
}

/*******************************************************************************
 Notification methods
 *******************************************************************************/

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDirtified:)
                                                 name:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                               object:nil];
}

// Called when an entity has been signalized as dirty
- (void)entityDirtified:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING]) {
        // Log
        NSLog (@"EntityStore info about dirtification");
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        if([dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY] != nil) {
            
            // Get the request data
            EntityReqNotificationData *reqData = (EntityReqNotificationData *)[dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
            
            switch (reqData.entityType) {
                case ENTITY_TYPE__DEVICE:
                    [self flagDeviceAsDirtyOrClean:reqData.entityId
                                                  :true];
                    break;
                case ENTITY_TYPE__DEVICE_GROUP:
                    [self flagDeviceGroupAsDirtyOrClean:reqData.entityId
                                                  :true];
                    break;                    
                default:
                    break;
            }
        }
    }
}

/*******************************************************************************
 ???????
 *******************************************************************************/

- (void)entityUpdated:(NSObject *) src : (SKEntity *) entity {
    if([entity isKindOfClass:[SKDevice class]]) {
        
    }
    
    NSLog(@"Updated id value :%i", entity.ID);
}

- (void)entityCollectionUpdated:(NSObject *) src:(NSMutableArray *) collection:(Class) entityClass {
    if([entityClass class] == [SKDevice class]){
        [self devicesUpdated:collection];
    }    
}

- (void)devicesUpdated:(NSMutableArray *)collection {
    // Store the devices internally
    deviceList = collection;
    // Clear list of dirty object
    [deviceDirtyList removeAllObjects];
    
    // Send a dictionary with devices to the receivers...
    NSDictionary *notificationData = [NSDictionary dictionaryWithObject:collection
                                                                 forKey:@"Devices"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICES_UPDATED
                                      object:nil
                                    userInfo:notificationData];
    
}

// Flags an entity as dirty or clean
- (void)flagEntityAsDirtyOrClean:(SKEntity *)entity :(Boolean)isDirty {
    if([entity isKindOfClass:[SKDevice class]]) {
        [self flagDeviceAsDirtyOrClean:entity.ID 
                                      :isDirty];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        [self flagDeviceGroupAsDirtyOrClean:entity.ID 
                                      :isDirty];
    } else if([entity isKindOfClass:[SKDataSource class]]) {
        [self flagDeviceGroupAsDirtyOrClean:entity.ID 
                                           :isDirty];
    }
}

// Flags a device as dirty or clean
- (void)flagDeviceAsDirtyOrClean:(NSInteger)deviceId :(Boolean)isDirty {
    NSNumber *number = [NSNumber numberWithInt:deviceId];
    
    [deviceDirtyList removeObjectIdenticalTo:number];

    if(isDirty) {
        [deviceDirtyList addObject:number];
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
}

// Flags a device group as dirty or clean
- (void)flagDeviceGroupAsDirtyOrClean:(NSInteger)deviceId :(Boolean)isDirty {
    
}

// Indicates whether an entity is dirty or not
- (Boolean)entityIsDirty:(SKEntity *)entity {
    if([entity isKindOfClass:[SKDevice class]]) {
        return [self deviceIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        return [self deviceGroupIsDirty:entity.ID];
    }
    
    return true;
}

// Indicates whether a device is dirty or not
- (Boolean)deviceIsDirty:(NSInteger)deviceId {
    if([deviceDirtyList count] == 0)
        return false;
    
    NSNumber *number = [NSNumber numberWithInt:deviceId];
    
    NSInteger f = [deviceDirtyList indexOfObjectIdenticalTo:number];
    
    if(f < 10) {
        return true;
    }
    
    Boolean notFound = ([deviceDirtyList indexOfObjectIdenticalTo:number] == NSNotFound);

    return [deviceDirtyList indexOfObjectIdenticalTo:number] != NSNotFound;
}

// Indicates whether a device group is dirty or not
- (Boolean)deviceGroupIsDirty:(NSInteger)deviceGroupId {
    return true;
}

@end
