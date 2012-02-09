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
#import "SKDataSourceGroup.h"
#import "DeviceListViewController.h"
#import "EntityHttpReqNotificationData.h"
#import "SKEvent.h"
#import "SKScenario.h"
#import "SKSystemSetting.h"
#include "Constants.h"
#import "SettingsMgr.h"

@implementation EntityStore
{
    Boolean eventsDirty;
    NSMutableArray *eventList;
    
    NSMutableArray *deviceList;
    NSMutableArray *deviceGroupList;
    NSMutableDictionary *deviceDirtyList;
    NSMutableDictionary *deviceGroupDirtyList;
    
    NSMutableArray *dataSourceList;
    NSMutableArray *dataSourceGroupList;
    NSMutableDictionary *dataSourceDirtyList;
    NSMutableDictionary *dataSourceGroupDirtyList;
    
    NSMutableArray *scenarioList;
    Boolean scenariosDirty;
}

@synthesize deviceListViewController;

- (EntityStore *)init {
    self = [super init];
    
    deviceDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];
    deviceGroupDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];

    dataSourceDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];
    dataSourceGroupDirtyList = [[NSMutableDictionary alloc] initWithCapacity:50];
    
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
                case ENTITY_TYPE__DATA_SOURCE:
                    [self flagDataSourceAsDirtyOrClean:reqData.entityId
                                                  :true];
                    break;
                case ENTITY_TYPE__DATA_SOURCE_GROUP:
                    [self flagDataSourceGroupAsDirtyOrClean:reqData.entityId
                                                       :true];
                    break;
                case ENTITY_TYPE__EVENTS:
                    [self flagAllEventsAsDirtyOrClean:true];
                    break; 
                case ENTITY_TYPE__SCENARIO:
                    [self flagAllScenariosAsDirtyOrClean:true];
                    break; 
                case ENTITY_TYPE__ALL_ENTITIES:
                {
                    [self flagAllDeviceEntitiesAsDirtyOrClean:true];
                    [self flagAllDataSourceEntitiesAsDirtyOrClean:true];
                    [self flagAllEventsAsDirtyOrClean:true];
                    [self flagAllScenariosAsDirtyOrClean:true];
                    
                    break;    
                }
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
    } else if([entity isKindOfClass:[SKDataSource class]]) {
        [self dataSourceUpdated:(SKDataSource *)entity];
    } else if([entity isKindOfClass:[SKEvent class]]) {
        //[self eventUpdated:(SKEvent *)entity];
    } else if([entity isKindOfClass:[SKScenario class]]) {
        [self scenarioUpdated:(SKScenario *)entity];
    } else if([entity isKindOfClass:[SKSystemSetting class]]) {
        [self systemSettingUpdated:(SKSystemSetting *)entity];
    } 
    
    NSLog(@"Updated id value :%i", entity.ID);
}

- (void)entityCollectionUpdated:(NSObject*) src:(NSMutableArray *) collection:(Class) entityClass {
    if([entityClass class] == [SKDevice class]) {
        [self devicesUpdated:collection];
    } else if([entityClass class] == [SKDataSource class]) {
        [self dataSourcesUpdated:collection];
    } else if([entityClass class] == [SKEvent class]) {
        [self eventsUpdated:collection];
    } else if([entityClass class] == [SKScenario class]) {
        [self scenariosUpdated:collection];
    } else if([entityClass class] == [SKSystemSetting class]) {
        [self systemSettingsUpdated:collection];        
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

- (void)dataSourceUpdated:(SKDataSource*)dataSource {
    if(dataSourceList.count == 0) {
        // If the dataSource list is empty, create a new dataSource...
        [self dataSourcesUpdated:[NSMutableArray arrayWithObject:dataSource]];
    } else {
        NSUInteger idx = [dataSourceList indexOfObjectPassingTest:
                          ^ BOOL (SKDataSource* ds, NSUInteger idx, BOOL *stop)
                          {
                              return ds.ID == dataSource.ID;
                          }];
        
        if(idx == NSNotFound) {
            NSLog(@"%@", @"DataSource not found");
        } else {
            [dataSourceList replaceObjectAtIndex:idx withObject:dataSource];
            
            // Indicate that this dataSource is now clean
            [self flagDataSourceAsDirtyOrClean:dataSource.ID :false];
            
            // Send a dictionary with dataSources to the receivers...
            NSDictionary *notificationData = [NSDictionary dictionaryWithObject:dataSourceList
                                                                         forKey:@"DataSources"];
            
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:NOTIFICATION_NAME__DATA_SOURCES_UPDATED
                                              object:nil
                                            userInfo:notificationData];        }        
    }
}

- (void)dataSourcesUpdated:(NSMutableArray*)collection {
    // Store the devices internally
    dataSourceList = collection;
    // Clear list of dirty object
    [dataSourceDirtyList removeAllObjects];
    [dataSourceGroupDirtyList removeAllObjects];
    
    //[self createDeviceGroupStructure:deviceList];
    
    // Send a dictionary with devices to the receivers...
    NSDictionary* notificationData = [NSDictionary dictionaryWithObject:collection
                                                                 forKey:@"DataSources"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DATA_SOURCES_UPDATED
                                      object:nil
                                    userInfo:notificationData];
    
}

- (void)eventsUpdated:(NSMutableArray*)collection {
    // Store the devices internally
    eventList = collection;
    // Clear list of dirty object
    eventsDirty = false;
    
    // Send a dictionary with devices to the receivers...
    NSDictionary* notificationData = [NSDictionary dictionaryWithObject:collection
                                                                 forKey:@"Events"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__EVENTS_UPDATED
                                      object:nil
                                    userInfo:notificationData];
    
}

- (void)systemSettingUpdated:(SKSystemSetting*)setting {
    if(setting != nil && [SYSTEM_SETTING_NAME__SERVER_VERSION isEqualToString:setting.Name]) {
        [SettingsMgr setServerVersion:setting.Value];
        [SettingsMgr setNeedServerVersionUpdate:false];
        
        Boolean validForHistoricEvents = false;
        
        if(setting.Value != nil) {
            NSRange notValidForHistoricEvents1 = [setting.Value rangeOfString:@"2.0.2"];
            NSRange notValidForHistoricEvents2 = [setting.Value rangeOfString:@"1."];
            
            if(notValidForHistoricEvents1.location == NSNotFound && notValidForHistoricEvents2.location == NSNotFound) {
                validForHistoricEvents = true;
            } else if(notValidForHistoricEvents1.location == 0 || notValidForHistoricEvents2.location == 0) {
                validForHistoricEvents = false;
            }
        }
        
        [SettingsMgr setSupportsHistoricEvents:validForHistoricEvents];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:NOTIFICATION_NAME__SERVER_VERSION_UPDATED
                                          object:nil
                                        userInfo:nil];
    }
}

- (void)systemSettingsUpdated:(NSMutableArray*)collection {
    for (int i=0; i<collection.count; i++) {
        [self systemSettingUpdated:(SKSystemSetting *)[collection objectAtIndex:i]];
    }
}

- (void)scenarioUpdated:(SKScenario*)scenario {
    if(scenarioList.count == 0) {
        // If the dataSource list is empty, create a new dataSource...
        [self scenariosUpdated:[NSMutableArray arrayWithObject:scenario]];
    } else {
        NSUInteger idx = [scenarioList indexOfObjectPassingTest:
                          ^ BOOL (SKScenario* ds, NSUInteger idx, BOOL *stop)
                          {
                              return ds.ID == scenario.ID;
                          }];
        
        if(idx == NSNotFound) {
            NSLog(@"%@", @"Scenario not found");
        } else {
            [scenarioList replaceObjectAtIndex:idx withObject:scenario];
            
            // Indicate that this scenario is now clean
            [self flagAllScenariosAsDirtyOrClean:false];
            
            // Send a dictionary with scenarios to the receivers...
            NSDictionary *notificationData = [NSDictionary dictionaryWithObject:scenarioList
                                                                         forKey:@"Scenarios"];
            
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:NOTIFICATION_NAME__SCENARIOS_UPDATED
                                              object:nil
                                            userInfo:notificationData];        }        
    }
}

- (void)scenariosUpdated:(NSMutableArray*)collection {
    // Store the entities internally
    scenarioList = collection;
    // Clear list of dirty object
    scenariosDirty = false;
    
    // Send a dictionary with entities to the receivers...
    NSDictionary* notificationData = [NSDictionary dictionaryWithObject:collection
                                                                 forKey:@"Scenarios"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__SCENARIOS_UPDATED
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
    } else if([entity isKindOfClass:[SKDataSourceGroup class]]) {
        [self flagDataSourceGroupAsDirtyOrClean:entity.ID 
                                           :isDirty];
    } else if([entity isKindOfClass:[SKEvent class]]) {
        [self flagAllEventsAsDirtyOrClean:isDirty];
    } else if([entity isKindOfClass:[SKScenario class]]) {
        [self flagAllScenariosAsDirtyOrClean:isDirty];
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

// Flags ALL device entities as dirty or clean
- (void)flagAllDeviceEntitiesAsDirtyOrClean:(Boolean)isDirty {
    NSMutableSet *deviceGroupIds = [[NSMutableSet alloc] init];
    
    for(int i=0;i<[deviceList count];i++) {
        SKDevice *d = (SKDevice *)[deviceList objectAtIndex:i];
        
        [deviceGroupIds addObject:[NSNumber numberWithInteger:d.GroupID]];
    }
    
    NSArray *groupIdsArray = [deviceGroupIds allObjects];
    
    for(int i=0;i<[groupIdsArray count];i++) {
        NSInteger groupId = [(NSNumber *)[groupIdsArray objectAtIndex:i] integerValue];
        
        [self flagDeviceGroupAsDirtyOrClean:groupId
                                           :true];    
    }
}

// Flags a data source as dirty or clean
- (void)flagDataSourceAsDirtyOrClean:(NSInteger)dataSourceId: (Boolean)isDirty {
    [dataSourceDirtyList setObject:[NSNumber numberWithBool:isDirty] forKey:[NSNumber numberWithInt:dataSourceId]];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DATA_SOURCE_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
}

// Flags a data source group as dirty or clean
- (void)flagDataSourceGroupAsDirtyOrClean:(NSInteger)dataSourceGroupId: (Boolean)isDirty {
    [dataSourceGroupDirtyList setObject:[NSNumber numberWithBool:isDirty] forKey:[NSNumber numberWithInt:dataSourceGroupId]];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DATA_SOURCE_GROUP_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];

}

// Flags ALL data source entities as dirty or clean
- (void)flagAllDataSourceEntitiesAsDirtyOrClean:(Boolean)isDirty {
    NSMutableSet *dataSourceGroupIds = [[NSMutableSet alloc] init];
    
    for(int i=0;i<[dataSourceList count];i++) {
        SKDataSource *ds = (SKDataSource *)[dataSourceList objectAtIndex:i];
        
        [dataSourceGroupIds addObject:[NSNumber numberWithInteger:ds.GroupID]];
    }
    
    NSArray *groupIdsArray = [dataSourceGroupIds allObjects];
    
    for(int i=0;i<[groupIdsArray count];i++) {
        NSInteger groupId = [(NSNumber *)[groupIdsArray objectAtIndex:i] integerValue];
        
        [self flagDataSourceGroupAsDirtyOrClean:groupId
                                           :true];    
    }
}

// Flags ALL event entities as dirty or clean
- (void)flagAllEventsAsDirtyOrClean:(Boolean)isDirty {
    eventsDirty = isDirty;
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__EVENTS_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
}

// Flags ALL entities as dirty or clean
- (void)flagAllScenariosAsDirtyOrClean:(Boolean)isDirty {
    scenariosDirty = isDirty;
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__SCENARIOS_DIRTIFICATION_UPDATED
                                      object:nil
                                    userInfo:nil];
}


// Indicates whether an entity is dirty or not
- (Boolean)entityIsDirty:(SKEntity *)entity {
    if([entity isKindOfClass:[SKDevice class]]) {
        return [self deviceIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        return [self deviceGroupIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKDataSource class]]) {
        return [self dataSourceIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKDataSourceGroup class]]) {
        return [self dataSourceGroupIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKEvent class]]) {
        return [self eventIsDirty:entity.ID];
    } else if([entity isKindOfClass:[SKScenario class]]) {
        return [self scenarioIsDirty:entity.ID];
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

// Indicates whether a data source is dirty or not
- (Boolean)dataSourceIsDirty:(NSInteger)dataSourceId {
    if(
       [dataSourceDirtyList count] == 0 &&
       [dataSourceGroupDirtyList count] == 0)
        return false;
    
    NSNumber* dataSourceIdInDict = [dataSourceDirtyList objectForKey:[NSNumber numberWithInt:dataSourceId]];
    
    if(dataSourceIdInDict == nil) {
        SKDataSource *dataSource = [self getDataSourceById:dataSourceId];
        Boolean dirtyByDataSourceGroup = [self dataSourceGroupIsDirty:dataSource.GroupID];
        
        return dirtyByDataSourceGroup;
    } else {
        if([dataSourceIdInDict boolValue])
            return true;
        else {
            SKDataSource *dataSource = [self getDataSourceById:dataSourceId];
            Boolean dirtyByDataSourceGroup = [self dataSourceGroupIsDirty:dataSource.GroupID];
            
            return dirtyByDataSourceGroup;    
        }
    }
}

// Indicates whether a data source group is dirty or not
- (Boolean)dataSourceGroupIsDirty:(NSInteger)dataSourceGroupId {
    if([dataSourceGroupDirtyList count] == 0)
        return false;
    
    NSNumber* number = [dataSourceGroupDirtyList objectForKey:[NSNumber numberWithInt:dataSourceGroupId]];
    
    if(number == nil)
        return false;
    else
        return [number boolValue];
}

// Indicates whether an event is dirty or not
- (Boolean)eventIsDirty:(NSInteger)eventId {
    return eventsDirty;
}

// Indicates whether a scenario is dirty or not
- (Boolean)scenarioIsDirty:(NSInteger)scenarioId {
    return scenariosDirty;
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

// Gets the data source by a specific id
- (SKDataSource*)getDataSourceById:(NSInteger)dataSourceId {
    NSUInteger idx = [dataSourceList indexOfObjectPassingTest:
                      ^ BOOL (SKDataSource* ds, NSUInteger idx, BOOL *stop)
                      {
                          return ds.ID == dataSourceId;
                      }];
    
    if(idx == NSNotFound) {
        NSLog(@"%@", @"DataSource not found");
        return nil;
    } else {
        return [dataSourceList objectAtIndex:idx];
    }
}

// Gets the data source group by a specific id
- (SKDataSourceGroup*)getDataSourceGroupById:(NSInteger)dataSourceGroupId {
    
}
@end
