//
//  CommunicationMgr.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommunicationMgr.h"
#import "AuthenticationDataContainer.h"
#import "SKDeviceDataReceiver.h"
#import "SKDataSourceDataReceiver.h"
#import "SKEventDataReceiver.h"
#import "SKScenarioDataReceiver.h"
#import "SKSystemSettingDataReceiver.h"
#import "CommunicationBase.h"
#import "EntityStore.h"
#import "SettingsMgr.h"
#import "AppDelegate.h"
#import "EntityRequestGenerator.h"
#import "EntityHttpReqNotificationData.h"
#include "Constants.h"
#import "NotificationHelper.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation CommunicationMgr

/*******************************************************************************
 Init methods
 *******************************************************************************/

// Initializes the manager, adding entity observers to be able to listen to
// notifications.
- (CommunicationMgr*)init {
    self = [super init];

    [self addEntityObservers];
    
    return self;
}

/*******************************************************************************
 Notification methods
 *******************************************************************************/

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdateRequested:)
                                                 name:NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdateCancellationRequested:)
                                                 name:NOTIFICATION_NAME__ENTITY_UPDATE_REQUEST_CANCELLED
                                               object:nil];
}

// Called when timer ticks
- (void)entityDataUpdateRequestedOnTick:(NSTimer *)timer {
    // Log
    NSLog (@"EntityDataUpdate onTick");
    
    NSDictionary *dict = [timer userInfo];
    // Get the request data
    EntityHttpReqNotificationData *reqData = [dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];

    // Interpret and handle...
    [self interpretAndHandleNotificationData:reqData];
}

// Called when a request has been made to update a specific entity by fetching
// data from the server.
// The request can either be
// 1) A request to update the device NOW
// or
// 2) A request to update the device after a specific amount of time.
//    When the specified amount of time has passed, a trigger is triggered
//    which causes the app to fetch data from server.
- (void)entityDataUpdateRequested:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED]) {
        // Log
        NSLog (@"CommunicationMgr received an entity update request");
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
              
        // Get the request data
        EntityHttpReqNotificationData *reqData = (EntityHttpReqNotificationData *)[dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        if(reqData != nil) {
            if(reqData.reqDelay > 0) {
                // Delay...
                [NSTimer scheduledTimerWithTimeInterval:reqData.reqDelay
                                                 target:self
                                               selector:@selector(entityDataUpdateRequestedOnTick:)
                                               userInfo:dict
                                                repeats:NO];
            } else {
                // Interpret and handle ASAP...
                [self interpretAndHandleNotificationData:reqData];
  
            }
            // Pass the device data to the method
            //[self handleUpdatedDevices:[dict valueForKey:@"Devices"]]; 
        } else {
            NSLog(@"Empty request.");
        }
    }
}

// Called when a request for update has been cancelled
- (void)entityDataUpdateCancellationRequested:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__ENTITY_UPDATE_REQUEST_CANCELLED]) {
        // Log
        NSLog (@"CommunicationMgr received an entity update cancellation request");
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        // Get the request data
        EntityHttpReqNotificationData *reqData = [dict valueForKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        if(reqData == nil) {
            // Pass the device data to the method
            //[self handleUpdatedDevices:[dict valueForKey:@"Devices"]]; 
        } else {
            NSLog(@"Empty cancellation request.");
        }
    }  
}

- (void)interpretAndHandleNotificationData:(EntityHttpReqNotificationData *) reqNotData {
    switch (reqNotData.entityType) {
        case ENTITY_TYPE__DEVICE:
            NSLog(@"%@", @"Interpreted entity req notification as Device");
            [self updateDevice:reqNotData.entityId];
            break;
            
        case ENTITY_TYPE__DEVICE_GROUP:
            NSLog(@"%@", @"Interpreted entity req notification as DeviceGroup");
            [self updateDeviceGroup:reqNotData.entityId];
            break;
            
        case ENTITY_TYPE__SCENARIO:
            NSLog(@"%@", @"Interpreted entity req notification as Scenario");
            [self updateScenarios];
            break;            
            
        default:
            NSLog(@"Missing or invalid entity type (%i) while interpreting entity req notification", reqNotData.entityType);
            break;
    }
}

/*******************************************************************************
 Update Request methods
 *******************************************************************************/

- (void)requestEntityAction:(EntityActionRequest *)req {
    // Get the authentication data container
    AuthenticationDataContainer *auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    
    NSString *reqPath;
    
    if(req.actionId == ACTION_ID__SYNCHRONIZE) {
        reqPath = [EntityRequestGenerator getDeviceSynchronizeRequestPath:req.entity];
    } else if(req.actionId == ACTION_ID__CHANGE_SCENARIO) {
        reqPath = [EntityRequestGenerator getScenarioChangeRequestPath:req.entity];        
    } else {
        reqPath = [EntityRequestGenerator getDeviceActionRequestPath:req.entity 
                                                                    :req.actionId 
                                                                    :req.dimLevel];
    }
    
    NSString *url = [[communicationBase getBaseUrl] stringByAppendingString:reqPath];

    EntityHttpReqNotificationData *reqNotificationData = [req toNotificationData];
    
    if([req.entity isKindOfClass:[SKDevice class]]) {        
        reqNotificationData.reqDelay = [SettingsMgr getDeviceUpdateDelay];
    } else if([req.entity isKindOfClass:[SKDeviceGroup class]]) {        
        reqNotificationData.reqDelay = [SettingsMgr getDeviceGroupUpdateDelay]; 
    } else if([req.entity isKindOfClass:[SKScenario class]]) {
        reqNotificationData.reqDelay = REFRESH_INTERVAL__SCENARIO_CHANGE; 
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    if([CommunicationMgr hasConnectivity]) {
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [communicationBase sendRequest:url];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED
                                          object:nil
                                        userInfo:notificationData];
    
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    }
}


- (void)requestUpdateOfDevices {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
    
    reqNotificationData.entityType = ENTITY_TYPE__DEVICE;
    
    if([CommunicationMgr hasConnectivity]) {
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
        
        [self updateDevices];
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    }
}

- (void)requestUpdateOfDataSources {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
    
    reqNotificationData.entityType = ENTITY_TYPE__DATA_SOURCE;
    
    if([CommunicationMgr hasConnectivity]) {
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
        
        [self updateDataSources];
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    }
}

- (void)requestUpdateOfEvents {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
    
    reqNotificationData.entityType = ENTITY_TYPE__EVENTS;
    
    if([CommunicationMgr hasConnectivity]) {
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
        
        [self updateEventsComingUp];
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    }
}

- (void)requestUpdateOfScenarios {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
    
    reqNotificationData.entityType = ENTITY_TYPE__SCENARIO;
    
    if([CommunicationMgr hasConnectivity]) {
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
        
        [self updateScenarios];
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    } 
}

// Requests all entities to be updated
// May be called at init of the app
- (void)requestUpdateOfAllEntities {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    if([CommunicationMgr hasConnectivity]) {
        EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
        
        reqNotificationData.entityType = ENTITY_TYPE__ALL_ENTITIES;
        
        NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                     forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
        
        [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                          object:nil
                                        userInfo:notificationData];
        
        if([SettingsMgr needServerVersionUpdate]) {
            [self updateSystemSettingServerVersion];
        } else {            
            [self updateAllEntities];
        }
    } else {
        [CommunicationMgr notifyNoConnection:notificationCenter];
    }
}

/*******************************************************************************
 Update methods
 *******************************************************************************/

- (void)updateAllEntities {
    [self updateDevices];
    [self updateDataSources];
    [self updateEventsComingUp];
    [self updateScenarios];
}

- (void)updateDevices {
    NSLog(@"Updating devices");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    
    // Create a receiver and assign an entity store to the receiver
    SKDeviceDataReceiver *receiver = [[SKDeviceDataReceiver alloc] initWithEntityStore:appDelegate.entityStore];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getDeviceListUrl]];
    
    NSLog(@"Request for all devices sent");
}

- (void)updateDevice:(NSInteger)deviceId {
    NSString *log = [NSString stringWithFormat:@"Updating device with id %i", deviceId];
    NSLog(@"%@", log);
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    
    // Create a receiver and assign an entity store to the receiver
    SKDeviceDataReceiver *receiver = [[SKDeviceDataReceiver alloc] initWithEntityStore:appDelegate.entityStore];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getDeviceUrl:deviceId]];
    
    NSLog(@"Device request sent");
}

- (void)updateDeviceGroup:(NSInteger)deviceGroupId {
    NSString *log = [NSString stringWithFormat:@"Updating device group with id %i", deviceGroupId];
    NSLog(@"%@", log);
    
    // Rewrite to update of devices...
    [self updateDevices];
}


- (void)updateDataSources {
    NSLog(@"Updating data sources");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    
    // Create a receiver and assign an entity store to the receiver
    SKDataSourceDataReceiver *receiver = [[SKDataSourceDataReceiver alloc] initWithEntityStore:appDelegate.entityStore];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getDataSourceListUrl]];
    
    NSLog(@"Request for all data sources sent");

}

- (void)updateEventsComingUp {
    NSLog(@"Updating events coming up");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    // The store
    EntityStore *store = appDelegate.entityStore;
    
    // Create a receiver and assign an entity store to the receiver
    SKEventDataReceiver *receiver = [[SKEventDataReceiver alloc] initWithEntityStore:store];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    NSInteger maxCount = [SettingsMgr getMaxUpcomingEvents];
    Boolean historicAndFuture = [SettingsMgr supportsHistoricEvents];
    NSString *url;
    
    if(historicAndFuture)
        url = [communicationBase getHistoricAndFutureEventsListUrl:maxCount];
    else
        url = [communicationBase getFutureEventsListUrl:maxCount];
    
    // Send the request
    [communicationBase sendRequest:url];
    
    NSLog(@"Request for all upcoming events");
}

- (void)updateScenarios {
    NSLog(@"Updating scenarios");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :true];
    
    // Create a receiver and assign an entity store to the receiver
    SKScenarioDataReceiver *receiver = [[SKScenarioDataReceiver alloc] initWithEntityStore:appDelegate.entityStore];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getScenarioListUrl]];
    
    NSLog(@"Request for all scenarios");
}

- (void)updateSystemSettingServerVersion {
    NSLog(@"Updating system setting version");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth
                                                                                                :false];
    
    // Create a receiver and assign an entity store to the receiver
    SKSystemSettingDataReceiver *receiver = [[SKSystemSettingDataReceiver alloc] initWithEntityStore:appDelegate.entityStore];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getSystemSettingVersionUrl]];
    
    NSLog(@"Request for update of system setting version");
}

/*******************************************************************************
 Connectivity methods
 *******************************************************************************/

+ (void)notifyNoConnection:(NSNotificationCenter *)notificationCenter {
    NSString *alertNotificationData = NSLocalizedStringFromTable(@"No network connection", @"Texts", nil);
    
    NSDictionary *notificationData = [NSDictionary dictionaryWithObject:alertNotificationData 
                                                                 forKey:ALERT_INFO_NOTIFICATION__ALERT_MSG_KEY];
    
    [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                      object:nil
                                    userInfo:notificationData];
    
    // Post a notification that an alert is requested to display
    [notificationCenter postNotificationName:NOTIFICATION_NAME__ALERT_INFO_REQUESTED
                                      object:nil
                                    userInfo:notificationData];
    
    // Post a notification that connection is not available
    [notificationCenter postNotificationName:NOTIFICATION_NAME__NO_CONNECTION
                                      object:nil
                                    userInfo:nil];
}

/* 
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 */
+ (BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}


@end
