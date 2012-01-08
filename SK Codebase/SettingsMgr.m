//
//  SettingsStore.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsMgr.h"
#import "AuthenticationDataContainer.h"

@implementation SettingsMgr

// Gets an indication whether settings are configured or not
+ (Boolean)settingsConfigured {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"settingsConfigured";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether settings are configured or not
+ (void)setSettingsConfigured:(Boolean) configured {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"settingsConfigured";
    
    // set the value
    [defaults setBool:configured forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether to use live or not
+ (Boolean)useLive {
    if(![SettingsMgr settingsConfigured])
        return false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"useLive";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];

    return retrievedValue;
}

// Sets an indication whether to use live or not
+ (void)setUseLive:(Boolean) useLive {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"useLive";
    
    // set the value
    [defaults setBool:useLive forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets the address to connect to
+ (NSString *)getTargetAddress {
    if([self useLive])
        return @"http://live.switchking.se";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetAddress";
    
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:key];
    
    if(retrievedValue == nil)
        return @"http://live.switchking.se";
    
    return retrievedValue;
}

// Sets the address to connect to
+ (void)setTargetAddress:(NSString *) targetAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetAddress";
    
    // set the value
    [defaults setObject:targetAddress forKey:key];
    
    // save it
    [defaults synchronize];
    
}

// Gets the port to connect to
+ (NSInteger)getTargetPort {
    if([self useLive])
        return 8800;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetPort";
    
    // Get the result
    NSInteger retrievedValue = [defaults integerForKey:key];
    
    if(retrievedValue == 0)
        return 10800;
    
    return retrievedValue;
}

// Sets the port to connect to
+ (void)setTargetPort:(NSInteger) targetPort {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetPort";
    
    // set the value
    [defaults setInteger:targetPort forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets the stored authentication data
+ (AuthenticationDataContainer *)getAuthenticationData {
    AuthenticationDataContainer *container = [AuthenticationDataContainer alloc];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey = @"user";
    NSString *passKey = @"pass";
    
    // Get the result
    NSString *retrievedUserValue = [defaults stringForKey:userKey];
    NSString *retrievedPassValue = [defaults stringForKey:passKey];
    
    container.user = retrievedUserValue;
    container.pass = retrievedPassValue;
    
    return container;
}

// Sets the authentication data
+ (void)setAuthenticationData:(AuthenticationDataContainer *) data {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey = @"user";
    NSString *passKey = @"pass";
    
    if(data == nil) {
        // set the value
        [defaults setObject:nil forKey:userKey];
        [defaults setObject:nil forKey:passKey];
    } else {
        // set the value
        [defaults setObject:data.user forKey:userKey];
        [defaults setObject:data.pass forKey:passKey];
    }
    
    // save it
    [defaults synchronize];
}

// Gets the number of seconds to wait before requesting update of device state
// after an action has been requested.
+ (NSTimeInterval)getDeviceUpdateDelay {
    return 2;
}

// Gets the number of seconds to wait before requesting update of device group state
// after an action has been requested.
+ (NSTimeInterval)getDeviceGroupUpdateDelay {
    return 5;
}

@end
