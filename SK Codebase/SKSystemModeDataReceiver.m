//
//  SKSystemModeDataReceiver.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSystemModeDataReceiver.h"
#import "XMLSKSystemModeParser.h"

@implementation SKSystemModeDataReceiver

- (SKSystemModeDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    [super setEntityStore:store];
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKSystemMode data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKSystemModeParser *eventParser = [XMLSKSystemModeParser alloc];
    
    [eventParser setEntityStore:super.entityStore];
    
    //Set delegate
    [xmlParser setDelegate:eventParser];
    
    [xmlParser parse];
}

@end