//
//  CommunicationBase.m
//  switchkingclient
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommunicationBase.h"
#import "AuthenticationDataContainer.h"
#import <UIKit/UIKit.h>
#import "DataReceivedDelegate.h"
#import "SettingsMgr.h"
#import "AppDelegate.h"
#import "Base64Enc.h"
#import "Constants.h"

static NSString *sMyLock1 = @"Lock1";


@implementation CommunicationBase

@synthesize receiverDelegate;

-(CommunicationBase *)initWithAuthenticationData:(AuthenticationDataContainer *) auth:(Boolean)notifyOnCommunicationError {
    self = [super init];
    authData = [[AuthenticationDataContainer alloc] init];
    
    [authData setPass:auth.pass];
    [authData setUser:auth.user];
    
    notifyOnError = notifyOnCommunicationError;
    
    return self;
}

-(void)sendRequest:(NSString *) url{
    @synchronized(sMyLock1) {    
    
    NSLog(@"SEND REQUEST");
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // Setup NSURLConnection
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:15.0];

    NSString *str = [NSString stringWithFormat:@"%@:%@", authData.user, authData.pass];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
   
    if([SettingsMgr useLive]) {
        [request setValue:[NSString stringWithFormat:@"%i", [SettingsMgr getServerIdentity]] forHTTPHeaderField:@"SKSrvId"];
    }
   
    //NSString *auth = @"Basic VGVzdDpUZXN0Mg==";//  [NSString stringWithFormat:@"Basic %@", [Base64Encoding encodeBase64WithData:data]];
    //NSString *auth = [NSString stringWithFormat:@"Basic %@", [Base64Encoding encodeBase64WithData:data]];
        
        NSString *encoded = [Base64Enc base64StringFromData:data length:data.length];
        NSString *auth = [NSString stringWithFormat:@"Basic %@", encoded];
        
        
    
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Sending request to %@", URL);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [appDelegate requestNetworkActivityIndicator];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData alloc];
    } else {
        // Inform the user that the connection failed.
    }
    
        NSLog(@"REQUEST SENT");
    }
}

- (NSURLCredential*)credentialWithAuthData {
    NSURLCredential *newCredential = [NSURLCredential credentialWithUser:authData.user
                                                                password:authData.pass
                                                             persistence:NSURLCredentialPersistenceNone];
    NSLog(@"USER: %@", authData.user);
    
    return newCredential;
}


// Post error notification to receivers
- (void)postErrorNotification:(NSString *)info {
    // Set the notification data    
    NSDictionary *notificationData = [NSDictionary dictionaryWithObject:info 
                                                                 forKey:ALERT_INFO_NOTIFICATION__ALERT_MSG_KEY];

    
    // Post a notification that an alert is requested to display
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME__ALERT_INFO_REQUESTED
                                                        object:nil
                                                      userInfo:notificationData];
}

// NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [self credentialWithAuthData];

        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");    
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
    
    NSLog(@"Did receiveResp from %@", tgtUrl);
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    
        NSLog(@"Did receiveData from %@", tgtUrl);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
        NSLog(@"Did finish from %@", tgtUrl);
    
    // NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [appDelegate releaseNetworkActivityIndicator];
    
    if(receivedData.length == 0) {
        NSString *info = NSLocalizedStringFromTable(@"Server did not return any data.\nCheck username, password and server identity.", @"Texts", nil);
        
        if(!([appDelegate alertInfoInView] && [appDelegate.alertInfoText isEqualToString:info])) {
            if(notifyOnError) {
                // Post info about error
                [self postErrorNotification:info];
            }
        }
    }
    
        NSLog(@"Posting to delegate for %@", tgtUrl);
    
    [receiverDelegate dataReceived:self :receivedData];
    
            NSLog(@"Posted to delegate for %@", tgtUrl);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

    [appDelegate releaseNetworkActivityIndicator];
    
    NSString *info = [error localizedDescription];
    
    NSString *prefixInfo = NSLocalizedStringFromTable(@"Error loading data.\n%@", @"Texts", nil);
    
    if(info == nil) {
        NSString *dummyInfo = NSLocalizedStringFromTable(@"Either the server couldn't be contacted or there was an error during communication.", @"Texts", nil);
        info = [NSString stringWithFormat:prefixInfo, dummyInfo];
    } else {
        info = [NSString stringWithFormat:prefixInfo, info];
    }
    
    if(notifyOnError) {
        // Post info about error
        [self postErrorNotification:info];
    }
}

// Gets the base url
- (NSString *)getBaseUrl {
    NSString * address = [SettingsMgr getTargetAddress:true];
    NSInteger port = [SettingsMgr getTargetPort];
    NSString * portString = [NSString stringWithFormat:@":%d", port];
    
    NSString * lastChar = [address substringFromIndex:([address length] - 1)];
    
    if(lastChar == @"/")
        return [[address substringToIndex:([address length] - 1)] stringByAppendingString:portString];
    else
        
        return [address stringByAppendingString:portString];
}

// Gets the complete url to the device list
- (NSString *)getDeviceListUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/devices"];
}

// Gets the complete url to a single device
- (NSString *)getDeviceUrl:(NSInteger)deviceId {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:[NSString stringWithFormat:@"/devices/%d", deviceId]];
}

// Gets the complete url to the data source list
- (NSString *)getDataSourceListUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/datasources"];    
}

// Gets the complete url to the list with upcoming events
- (NSString *)getFutureEventsListUrl:(NSInteger)maxCount {
    NSString *url = [self getBaseUrl];
    NSString *param = [NSString stringWithFormat:@"/events/future?maxcount=%i", maxCount];
    return [url stringByAppendingString:param];
}

// Gets the complete url to the list with upcoming and historic events
- (NSString *)getHistoricAndFutureEventsListUrl:(NSInteger)maxCount {
    NSString *url = [self getBaseUrl];
    NSString *param = [NSString stringWithFormat:@"/events/historicandfuture?maxcount=%i", maxCount];
    return [url stringByAppendingString:param];
}

// Gets the complete url to the scenario list
- (NSString *)getScenarioListUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/scenarios"];
}

// Gets the complete url to the active scenario
- (NSString *)getActiveScenarioUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/scenarios/active"];
}

// Gets the complete url to the system setting containing version info
- (NSString *)getSystemSettingVersionUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/systemsettings/byname/ServerVersion"];    
}

// Gets the complete url to the information about days left
- (NSString *)getLiveDaysLeftUrl {
    NSString * url = [self getBaseUrl];
    return [url stringByAppendingString:@"/supportservices/licenses/daysleft"];    
}

@end
