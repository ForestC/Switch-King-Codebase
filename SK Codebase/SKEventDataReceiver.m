//
//  SKEventDataReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKEventDataReceiver.h"
#import "XMLSKEventParser.h"

@implementation SKEventDataReceiver

@synthesize entityStore;

- (SKEventDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    entityStore = store;
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKEvent data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKEventParser *eventParser = [XMLSKEventParser alloc];
    
    [eventParser setEntityStore:entityStore];
    
    //Set delegate
    [xmlParser setDelegate:eventParser];
    
    [xmlParser parse];
}

@end
