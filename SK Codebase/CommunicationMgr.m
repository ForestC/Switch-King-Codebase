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
#import "CommunicationBase.h"
#import "EntityStore.h"
#import "SettingsMgr.h"
#import "AppDelegate.h"
#import "EntityRequestGenerator.h"
#import "EntityHttpReqNotificationData.h"
#include "Constants.h"

@implementation CommunicationMgr

// The main update thread
NSThread * mainUpdateThread;

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
//                [self performSelector:@selector(entityDataUpdateRequestedOnTick:) 
//                           withObject:nil
//                           afterDelay:reqData.reqDelay];
//                
//                
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
            NSLog(@"%@", @"Interpreted entity req notification as Device");
            [self updateDeviceGroup:reqNotData.entityId];
            break;
            
        default:
            NSLog(@"%@", @"Missing or invalid entity type while interpreting entity req notification");
            break;
    }
}

/*******************************************************************************
 Request methods
 *******************************************************************************/

- (void)requestEntityAction:(EntityActionRequest *)req {
    // Get the authentication data container
    AuthenticationDataContainer *auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    
    NSString *reqPath = [EntityRequestGenerator getDeviceActionRequestPath:req.entity 
                                                                          :req.actionId 
                                                                          :req.dimLevel];

    NSString *url = [[communicationBase getBaseUrl] stringByAppendingString:reqPath];

    EntityHttpReqNotificationData *reqNotificationData = [req toNotificationData];
    NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                         forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
    
    [communicationBase sendRequest:url];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED
                                      object:nil
                                    userInfo:notificationData];
    
    [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                      object:nil
                                    userInfo:notificationData];
}

// Requests all entities to be updated
// May be called at init of the app
- (void)requestUpdateOfAllEntities {
    [self updateAllEntities];
}

- (void)updateAllEntities {
    [self updateDevices];
    [self updateDataSources];
}

- (void)updateDevices {
    NSLog(@"Updating devices");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    
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
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    
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
}


- (void)updateDataSources {
    NSLog(@"Updating datasources");
    
    // Create a receiver and assign an entity store to the receiver
    SKDataSourceDataReceiver *receiver = [SKDataSourceDataReceiver alloc];

    // Create a communication base    
    CommunicationBase *communicationBase = [self createCommunicationBase:receiver];
    
    // Send the request
    [communicationBase sendRequest:[communicationBase getDeviceListUrl]];

    NSLog(@"DataSource request sent");
}

- (void)updateComingUp {
    
}

// Creates a communication base object to be used when communicating with a remote server.
- (CommunicationBase *)createCommunicationBase:(NSObject <DataReceivedDelegate> *)del {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    if([del isKindOfClass:[SKDeviceDataReceiver class]]) {
        SKDeviceDataReceiver *typed = (SKDeviceDataReceiver *)del;
        typed.entityStore = appDelegate.entityStore;
    } else if([del isKindOfClass:[SKDataSourceDataReceiver class]]) {
        SKDataSourceDataReceiver *typed = (SKDataSourceDataReceiver *)del;
        typed.entityStore = appDelegate.entityStore;        
    } 
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    
    // Set the receiver delegate
    [communicationBase setReceiverDelegate:del];
    
    return communicationBase;
}

@end
