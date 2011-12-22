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

@implementation CommunicationMgr

// The main update thread
NSThread * mainUpdateThread;

- (void)requestEntityAction:(EntityActionRequest *)req {
    // Get the authentication data container
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    // Create a communication base    
    CommunicationBase *communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    
    COMMUNICATIONBASE måste prenumerera på en notification som tar hand om begäran om uppdatering av en en het
    
    NSString *reqPath = [EntityRequestGenerator getDeviceActionRequestPath:req.entity 
                                                                          :req.actionId 
                                                                          :req.dimLevel];

    NSString *url = [[communicationBase getBaseUrl] stringByAppendingString:reqPath];
    
    [communicationBase sendRequest:url];
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
    
    NSLog(@"Device request sent");
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
