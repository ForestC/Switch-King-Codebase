//
//  SKScenarioDataReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKScenarioDataReceiver.h"
#import "XMLSKScenarioParser.h"

@implementation SKScenarioDataReceiver

@synthesize entityStore;

- (SKScenarioDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    entityStore = store;
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKScenario data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKScenarioParser *eventParser = [XMLSKScenarioParser alloc];
    
    [eventParser setEntityStore:entityStore];
    
    //Set delegate
    [xmlParser setDelegate:eventParser];
    
    [xmlParser parse];
}

@end