//
//  SKSystemSettingDataReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSystemSettingDataReceiver.h"
#import "XMLSKSystemSettingParser.h"

@implementation SKSystemSettingDataReceiver

@synthesize entityStore;

- (SKSystemSettingDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    [super setEntityStore:store];
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKSystemSetting data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKSystemSettingParser *eventParser = [XMLSKSystemSettingParser alloc];
    
    [eventParser setEntityStore:entityStore];
    
    //Set delegate
    [xmlParser setDelegate:eventParser];
    
    [xmlParser parse];
}

@end