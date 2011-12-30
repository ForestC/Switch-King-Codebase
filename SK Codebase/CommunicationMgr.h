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
#import "EntityReqNotificationData.h"

@interface CommunicationMgr : NSObject {
    AuthenticationDataContainer *authData;
    //CommunicationBase *communicationBase;
    //SKDeviceDataReceiver *deviceDataReceiver;
}

- (void)addEntityObservers;

- (void)interpretAndHandleNotificationData:(EntityReqNotificationData *) reqNotData;

- (void)requestEntityAction:(EntityActionRequest *)req;

- (void)requestUpdateOfAllEntities;

- (void)updateAllEntities;

- (void)updateDevices;

- (void)updateDevice:(NSInteger)deviceId;

- (void)updateDeviceGroup:(NSInteger)deviceGroupId;

- (void)updateDataSources;

- (void)updateComingUp;

- (CommunicationBase *)createCommunicationBase:(NSObject <DataReceivedDelegate> *)del;

@end
