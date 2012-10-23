//
//  EntityStore.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDeviceStoreDelegate.h"
#import "DeviceListViewController.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKDataSource.h"
#import "SKDataSourceGroup.h"
#import "SKScenario.h"
#import "SKSystemSetting.h"
#import "SKSystemMode.h"

@interface EntityStore : NSObject <SKDeviceStoreDelegate> {
    
}

// Adds entity observers
- (void)addEntityObservers;

- (void)deviceUpdated:(SKDevice*)device;

- (void)devicesUpdated:(NSMutableArray*)collection;

- (void)dataSourceUpdated:(SKDataSource*)dataSource;

- (void)dataSourcesUpdated:(NSMutableArray*)collection;

- (void)eventsUpdated:(NSMutableArray*)collection;

- (void)scenarioUpdated:(SKScenario*)scenario;

- (void)scenariosUpdated:(NSMutableArray*)collection;

- (void)systemSettingUpdated:(SKSystemSetting*)setting;

- (void)systemSettingsUpdated:(NSMutableArray*)collection;

- (void)systemModeUpdated:(SKSystemMode*)setting;

- (void)systemModesUpdated:(NSMutableArray*)collection;

- (void)daysLeftOfLiveUsageUpdated:(NSInteger)daysLeft;

// Flags an entity as dirty or clean
- (void)flagEntityAsDirtyOrClean:(SKEntity*)entity: (Boolean)isDirty;

// Flags a device as dirty or clean
- (void)flagDeviceAsDirtyOrClean:(NSInteger)deviceId: (Boolean)isDirty;

// Flags a device group as dirty or clean
- (void)flagDeviceGroupAsDirtyOrClean:(NSInteger)deviceGroupId: (Boolean)isDirty;

// Flags ALL device entities as dirty or clean
- (void)flagAllDeviceEntitiesAsDirtyOrClean:(Boolean)isDirty;

// Flags a data source as dirty or clean
- (void)flagDataSourceAsDirtyOrClean:(NSInteger)dataSourceId: (Boolean)isDirty;

// Flags a data source group as dirty or clean
- (void)flagDataSourceGroupAsDirtyOrClean:(NSInteger)dataSourceGroupId: (Boolean)isDirty;

// Flags ALL data source entities as dirty or clean
- (void)flagAllDataSourceEntitiesAsDirtyOrClean:(Boolean)isDirty;

// Flags ALL event entities as dirty or clean
- (void)flagAllEventsAsDirtyOrClean:(Boolean)isDirty;

// Flags ALL scenario entities as dirty or clean
- (void)flagAllScenariosAsDirtyOrClean:(Boolean)isDirty;

// Flags ALL system mode entities as dirty or clean
- (void)flagAllSystemModesAsDirtyOrClean:(Boolean)isDirty;

// Indicates whether an entity is dirty or not
- (Boolean)entityIsDirty:(SKEntity *)entity;

// Indicates whether a device is dirty or not
- (Boolean)deviceIsDirty:(NSInteger)deviceId;

// Indicates whether a device group is dirty or not
- (Boolean)deviceGroupIsDirty:(NSInteger)deviceGroupId;

// Indicates whether a data source is dirty or not
- (Boolean)dataSourceIsDirty:(NSInteger)dataSourceId;

// Indicates whether a data source group is dirty or not
- (Boolean)dataSourceGroupIsDirty:(NSInteger)dataSourceGroupId;

// Indicates whether an event is dirty or not
- (Boolean)eventIsDirty:(NSInteger)eventId;

// Indicates whether a scenario is dirty or not
- (Boolean)scenarioIsDirty:(NSInteger)scenarioId;

// Indicates whether a system mode is dirty or not
- (Boolean)systemModeIsDirty:(NSInteger)systemModeId;

// Gets the id of the active scenario
- (NSInteger)getActiveScenarioId;

// Gets the id of the active system mode
- (NSInteger)getActiveSystemModeId;

// Gets the device by a specific id
- (SKDevice*)getDeviceById:(NSInteger)deviceId;

// Gets the data source by a specific id
- (SKDataSource*)getDataSourceById:(NSInteger)dataSourceId;

// Gets the data source group by a specific id
- (SKDataSourceGroup*)getDataSourceGroupById:(NSInteger)dataSourceGroupId;

@end
