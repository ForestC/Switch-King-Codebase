//
//  CommunicationMgr.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationDataContainer.h"
#import "CommunicationBase.h"
#import "DataReceivedDelegate.h"
#import "EntityActionRequest.h"
#import "EntityHttpReqNotificationData.h"
#import "EntityGraphRequest.h"

@interface CommunicationMgr : NSObject

- (void)addEntityObservers;

- (void)interpretAndHandleNotificationData:(EntityHttpReqNotificationData *) reqNotData;

- (void)requestEntityAction:(EntityActionRequest *)req;

- (void)requestUpdateOfDevices;

- (void)requestUpdateOfDataSources;

- (void)requestUpdateOfEvents;

- (void)requestUpdateOfScenarios;

- (void)requestUpdateOfSystemModes;

- (void)requestUpdateOfLiveDaysLeft;

- (void)requestUpdateOfAllEntities;

- (void)requestEntityGraph:(EntityGraphRequest *)req;

- (void)updateAllEntities;

- (void)updateDevices;

- (void)updateDevice:(NSInteger)deviceId;

- (void)updateDeviceGroup:(NSInteger)deviceGroupId;

- (void)updateDataSources;

- (void)updateEventsComingUp;

- (void)updateScenarios;

- (void)updateSystemModes;

- (void)updateSystemSettingServerVersion;

- (void)updateLiveDaysLeft;

+ (void)notifyNoConnection:(NSNotificationCenter *)notificationCenter;

+ (BOOL)hasConnectivity;

@end
