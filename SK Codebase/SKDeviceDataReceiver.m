//
//  SKDeviceDataReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDeviceDataReceiver.h"
#import "XMLSKDeviceParser.h"

@implementation SKDeviceDataReceiver

@synthesize entityStore;

- (SKDeviceDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    entityStore = store;

    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKDevice data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKDeviceParser *deviceParser = [XMLSKDeviceParser alloc];
    
    [deviceParser setEntityStore:entityStore];
    
    //Set delegate
    [xmlParser setDelegate:deviceParser];
    
    [xmlParser parse];
}

@end
