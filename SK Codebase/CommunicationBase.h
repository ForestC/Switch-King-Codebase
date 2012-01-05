//
//  CommunicationBase.h
//  switchkingclient
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationDataContainer.h"
#import "DataReceivedDelegate.h"

@interface CommunicationBase : NSObject
{
    NSMutableData * receivedData;
    AuthenticationDataContainer * authData;
    id<DataReceivedDelegate> receiverDelegate;
}

- (CommunicationBase *)initWithAuthenticationData:(AuthenticationDataContainer *)auth;

- (void)sendRequest:(NSString *)url;

// Gets the base url
- (NSString *)getBaseUrl;

// Gets the complete url to the device list
- (NSString *)getDeviceListUrl;

// Gets the complete url to a single device
- (NSString *)getDeviceUrl:(NSInteger)deviceId;

// Gets the complete url to the data source list
- (NSString *)getDataSourceListUrl;

@property (retain) id receiverDelegate;

@end
