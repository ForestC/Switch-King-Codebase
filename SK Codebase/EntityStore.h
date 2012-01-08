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

@interface EntityStore : NSObject <SKDeviceStoreDelegate> {
    
}

@property (nonatomic, strong) DeviceListViewController *deviceListViewController;

// Adds entity observers
- (void)addEntityObservers;

- (void)deviceUpdated:(SKDevice *) device;

- (void)devicesUpdated:(NSMutableArray *) collection;

// Flags an entity as dirty or clean
- (void)flagEntityAsDirtyOrClean:(SKEntity *)entity: (Boolean)isDirty;

// Flags a device as dirty or clean
- (void)flagDeviceAsDirtyOrClean:(NSInteger)deviceId: (Boolean)isDirty;

// Flags a device group as dirty or clean
- (void)flagDeviceGroupAsDirtyOrClean:(NSInteger)deviceId: (Boolean)isDirty;

// Indicates whether an entity is dirty or not
- (Boolean)entityIsDirty:(SKEntity *)entity;

// Indicates whether a device is dirty or not
- (Boolean)deviceIsDirty:(NSInteger)deviceId;

// Indicates whether a device group is dirty or not
- (Boolean)deviceGroupIsDirty:(NSInteger)deviceGroupId;

// Gets the id of the active scenario
- (NSInteger)getActiveScenarioId;

- (SKDevice *)getDeviceById:(NSInteger)deviceId;

@end
