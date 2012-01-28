//
//  CommunicationBase.m
//  switchkingclient
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommunicationBase.h"
#import "AuthenticationDataContainer.h"
#import "XMLSKDeviceParser.h"
#import <UIKit/UIKit.h>
#import "DataReceivedDelegate.h"
#import "SettingsMgr.h"
#import "AppDelegate.h"

@implementation CommunicationBase

@synthesize receiverDelegate;

-(CommunicationBase *)initWithAuthenticationData:(AuthenticationDataContainer *)auth {
    self = [super init];
    authData = auth;
    
    return self;
}

-(void)sendRequest:(NSString *) url{
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Setup NSURLConnection
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:15.0];
    
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
    
   // [connection start];
}

- (NSURLCredential*)credentialWithAuthData {
    NSURLCredential *newCredential = [NSURLCredential credentialWithUser:authData.user
                                                                password:authData.pass
                                                             persistence:NSURLCredentialPersistenceNone];
    NSLog(@"USER: %@", authData.user);
    
    return newCredential;
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
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [appDelegate releaseNetworkActivityIndicator];
    
    if(receivedData.length == 0) {
        NSString *info = NSLocalizedStringFromTable(@"Server did not return any data.\nCheck username, password and server identity.", @"Texts", nil);
        
        if(!([appDelegate alertInfoInView] && [appDelegate.alertInfoText isEqualToString:info])) {        
            [appDelegate setAlertInfo:info];
            [appDelegate toggleAlertInfo:true];
        }
    }
    
    [receiverDelegate dataReceived:self :receivedData];
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
    
    [appDelegate setAlertInfo:info];
    [appDelegate toggleAlertInfo:true];
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

@end
