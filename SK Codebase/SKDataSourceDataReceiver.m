//
//  SKDataSourceDataReceiver.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDataSourceDataReceiver.h"
#import "XMLSKDataSourceParser.h"

@implementation SKDataSourceDataReceiver

- (SKDataSourceDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    [super setEntityStore:store];
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKDataSource data received");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    XMLSKDataSourceParser *dataSourceParser = [XMLSKDataSourceParser alloc];
    
    [dataSourceParser setEntityStore:super.entityStore];
    
    //Set delegate
    [xmlParser setDelegate:dataSourceParser];
    
    [xmlParser parse];
}

@end
