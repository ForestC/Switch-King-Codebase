//
//  SKLiveDaysLeftReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKLiveDaysLeftReceiver.h"
#import "XMLSKLiveDaysLeftParser.h"

@implementation SKLiveDaysLeftReceiver

- (SKLiveDaysLeftReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    [super setEntityStore:store];
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKLiveDaysLeft data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKLiveDaysLeftParser *eventParser = [XMLSKLiveDaysLeftParser alloc];
    
    [eventParser setEntityStore:super.entityStore];
    
    //Set delegate
    [xmlParser setDelegate:eventParser];
    
    [xmlParser parse];
}

@end