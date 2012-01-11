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
#import "EntityHttpReqNotificationData.h"
#include "Constants.h"

@implementation EntityStore
{
    NSMutableArray* deviceList;
    NSMutableArray* deviceGroupList;
    NSMutableDictionary* deviceDirtyList;
    NSMutableDictionary* deviceGroupDirtyList;
}

@synthesize deviceListViewController;

- (EntityStore *)init {
    self = [super init];
    
    deviceDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];
    deviceGroupDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];
    
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
- (void)entityDirtified:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING]) {
        // Log
        NSLog (@"EntityStore info about dirtification");
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        if([dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY] != nil) {
            
            // Get the request data
            EntityHttpReqNotificationData *reqData = (EntityHttpReqNotificationData *)[dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
            
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

- (void)entityUpdated:(NSObject*) src : (SKEntity *) entity {
    if([entity isKindOfClass:[SKDevice class]]) {
        [self deviceUpdated:(SKDevice *)entity];
    }
    
    NSLog(@"Updated id value :%i", entity.ID);
}

- (void)entityCollectionUpdated:(NSObject*) src:(NSMutableArray *) collection:(Class) entityClass {
    if([entityClass class] == [SKDevice class]){
        [self devicesUpdated:collection];
    }    
}

- (void)deviceUpdated:(SKDevice*)device {
    if(deviceList.count == 0) {
        // If the device list is empty, create a new device...
        [self devicesUpdated:[NSMutableArray arrayWithObject:device]];
    } else {
        NSUInteger idx = [deviceList indexOfObjectPassingTest:
                          ^ BOOL (SKDevice* dev, NSUInteger idx, BOOL *stop)
                          {
                              return dev.ID == device.ID;
                          }];
        
        if(idx == NSNotFound) {
            NSLog(@"%@", @"Device not found");
        } else {
            [deviceList replaceObjectAtIndex:idx withObject:device];
            
            // Indicate that this device is now clean
            [self flagDeviceAsDirtyOrClean:device.ID :false];
            
            // Send a dictionary with devices to the receivers...
            NSDictionary *notificationData = [NSDictionary dictionaryWithObject:deviceList
                                                                         forKey:@"Devices"];
            
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICES_UPDATED
                                              object:nil
                                            userInfo:notificationData];        }        
    }
}

- (void)devicesUpdated:(NSMutableArray*)collection {
    // Store the devices internally
    deviceList = collection;
    // Clear list of dirty object
    [deviceDirtyList removeAllObjects];
    [deviceGroupDirtyList removeAllObjects];
    
    //[self createDeviceGroupStructure:deviceList];
    
    // Send a dictionary with devices to the receivers...
    NSDictionary* notificationData = [NSDictionary dictionaryWithObject:collection
                                                                 forKey:@"Devices"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICES_UPDATED
                                      object:nil
                                    userInfo:notificationData];
    
}

/*******************************************************************************
 Dirtification
 *******************************************************************************/

// Flags an entity as dirty or clean
- (void)flagEntityAsDirtyOrClean:(SKEntity*)entity :(Boolean)isDirty {
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
    [deviceDirtyList setObject:[NSNumber numberWithBool:isDirty] forKey:[NSNumber numberWithInt:deviceId]];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
}

// Flags a device group as dirty or clean
- (void)flagDeviceGroupAsDirtyOrClean:(NSInteger)deviceGroupId :(Boolean)isDirty {
    [deviceGroupDirtyList setObject:[NSNumber numberWithBool:isDirty] forKey:[NSNumber numberWithInt:deviceGroupId]];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICE_GROUP_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
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
    if(
       [deviceDirtyList count] == 0 &&
       [deviceGroupDirtyList count] == 0)
        return false;
    
    NSNumber* deviceIdInDict = [deviceDirtyList objectForKey:[NSNumber numberWithInt:deviceId]];
    
    if(deviceIdInDict == nil) {
        SKDevice *device = [self getDeviceById:deviceId];
        Boolean dirtyByDeviceGroup = [self deviceGroupIsDirty:device.GroupID];
        
        return dirtyByDeviceGroup;
    } else {
        if([deviceIdInDict boolValue])
            return true;
        else {
            SKDevice *device = [self getDeviceById:deviceId];
            Boolean dirtyByDeviceGroup = [self deviceGroupIsDirty:device.GroupID];
            
            return dirtyByDeviceGroup;    
        }
    }
}

// Indicates whether a device group is dirty or not
- (Boolean)deviceGroupIsDirty:(NSInteger)deviceGroupId {
    if([deviceGroupDirtyList count] == 0)
        return false;
    
    NSNumber* number = [deviceGroupDirtyList objectForKey:[NSNumber numberWithInt:deviceGroupId]];
    
    if(number == nil)
        return false;
    else
        return [number boolValue];
}

/*******************************************************************************
 ???????
 *******************************************************************************/

// Gets the id of the active scenario
- (NSInteger)getActiveScenarioId {
    return -1;
}

- (SKDevice *)getDeviceById:(NSInteger)deviceId {
    NSUInteger idx = [deviceList indexOfObjectPassingTest:
                      ^ BOOL (SKDevice* dev, NSUInteger idx, BOOL *stop)
                      {
                          return dev.ID == deviceId;
                      }];
    
    if(idx == NSNotFound) {
        NSLog(@"%@", @"Device not found");
        return nil;
    } else {
        return [deviceList objectAtIndex:idx];
    }
}

// Creates the internal device/group structure in order to provide easy access
// to the entities.
- (void)createDeviceGroupStructure:(NSMutableArray*)deviceData {
    NSMutableDictionary* tempGroupDictStore = [[NSMutableDictionary alloc] init];    
    NSMutableArray* devices = [[NSMutableArray alloc] initWithCapacity:deviceData.count];
    
    deviceGroupList = [[NSMutableArray alloc] initWithCapacity:deviceData.count];
    
    for(int n = 0; n < [deviceData count]; n = n + 1)
    {
        SKDevice * device = (SKDevice *)[deviceData objectAtIndex:n];
        
        NSString * groupId = [NSString stringWithFormat:@"%d", device.GroupID];
        
        SKDeviceGroup * group = (SKDeviceGroup *)[tempGroupDictStore valueForKey:groupId];
        
        if(group == nil) {
            SKDeviceGroup * newGroup = [SKDeviceGroup alloc];
            
            newGroup.Name = device.GroupName;
            newGroup.ID = device.GroupID;
            newGroup.devices = [[NSMutableArray alloc] init];
            [newGroup.devices addObject:device];
            
            [tempGroupDictStore setValue:newGroup forKey:[groupId copy]];            
        } else {
            [group.devices addObject:device];
            
            NSLog(@"Adding to group %@, now with %i devices", group.Name, group.devices.count);
        }
        
        [devices addObject:device]; 
    }
    
    // Set all group entities.
    [deviceGroupList setArray:[tempGroupDictStore allValues]];
}


@end
