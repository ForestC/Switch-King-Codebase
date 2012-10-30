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
    NSString *tgtUrl;
    Boolean notifyOnError;
    NSMutableData *receivedData;
    AuthenticationDataContainer *authData;
    id<DataReceivedDelegate> receiverDelegate;
    NSURLConnection *connection;
}

- (CommunicationBase *)initWithAuthenticationData:(AuthenticationDataContainer *) auth:(Boolean) notifyOnCommunicationError;

- (void)addEntityObservers;

- (void)sendRequest:(NSString *)url;

// Post error notification to receivers
- (void)postErrorNotification:(NSString *)info;

// Gets the base url
- (NSString *)getBaseUrl;

// Gets the complete url to the device list
- (NSString *)getDeviceListUrl;

// Gets the complete url to a single device
- (NSString *)getDeviceUrl:(NSInteger)deviceId;

// Gets the complete url to the data source list
- (NSString *)getDataSourceListUrl;

// Gets the complete url to the list with upcoming events
- (NSString *)getFutureEventsListUrl:(NSInteger)maxCount;

// Gets the complete url to the list with upcoming and historic events
- (NSString *)getHistoricAndFutureEventsListUrl:(NSInteger)maxCount;

// Gets the complete url to the scenario list
- (NSString *)getScenarioListUrl;

// Gets the complete url to the active scenario
- (NSString *)getActiveScenarioUrl;

// Gets the complete url to the system setting containing version info
- (NSString *)getSystemSettingVersionUrl;

// Gets the complete url to the system mode list
- (NSString *)getSystemModeListUrl;

// Gets the complete url to the active system mode
- (NSString *)getActiveSystemModeUrl;

// Gets the complete url to the information about days left
- (NSString *)getLiveDaysLeftUrl;

@property (retain) id receiverDelegate;

@end
