//
//  SettingsStore.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsMgr.h"
#import "AuthenticationDataContainer.h"
#import "Constants.h"

@implementation SettingsMgr

+ (void)initDefaults {
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"NO", @"useLive", 
                              @"YES", @"groupDevices", 
                              @"YES", @"groupDS", 
                              @"http://www.switchking.se", @"targetAddress",
                              @"10800", @"targetPort",
                              @"YES", @"needServerVersionUpdate",
                              @"YES", @"reloadOnTS",
                              @"1", @"qaMode",
                              @"0", @"serverIdentity",
                              nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

// Gets an indication whether settings are configured or not
+ (Boolean)initialSettingsConfigured {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"initialSettingsConfigured";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether settings are configured or not
+ (void)setInitialSettingsConfigured:(Boolean) configured {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"initialSettingsConfigured";
    
    // set the value
    [defaults setBool:configured forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether server version needs update
+ (Boolean)needServerVersionUpdate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"needServerVersionUpdate";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether server version needs update
+ (void)setNeedServerVersionUpdate:(Boolean) needServerVersionUpdate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"needServerVersionUpdate";
    
    // set the value
    [defaults setBool:needServerVersionUpdate forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether to use live or not
+ (Boolean)useLive {
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
    
    // Clear...
    [SettingsMgr clearDeviceGroupExpansionData];
}

// Gets an indication whether to group devices or not
+ (Boolean)groupDevices {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"groupDevices";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether to group devices or not
+ (void)setGroupDevices:(Boolean) groupDevices {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"groupDevices";
    
    // set the value
    [defaults setBool:groupDevices forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether to group data sources or not
+ (Boolean)groupDataSources {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"groupDS";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether to group data sources or not
+ (void)setGroupDataSources:(Boolean) groupDataSources {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"groupDS";
    
    // set the value
    [defaults setBool:groupDataSources forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether to enable learn button or not
+ (Boolean)showLearnButton {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"enableLearn";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether to enable learn button or not
+ (void)setShowLearnButton:(Boolean) enableLearnButton {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"enableLearn";
    
    // set the value
    [defaults setBool:enableLearnButton forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether to reload views on tab switch or not
+ (Boolean)enableReloadOnTabSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"reloadOnTS";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets an indication whether to reload views on tab switch or not
+ (void)setEnableReloadOnTabSwitch:(Boolean) enableReloadOnTabSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"reloadOnTS";
    
    // set the value
    [defaults setBool:enableReloadOnTabSwitch forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether swipe on device list is enabled or not
+ (Boolean)deviceListSwipeEnabled {
    return [SettingsMgr quickActionMode] == QUICK_ACTION_MODE__SWIPE;
}


// Gets an indication whether swipe on device list is enabled or not
+ (Boolean)deviceListToggleEnabled {
    NSInteger mode = [SettingsMgr quickActionMode];
    
    return mode == QUICK_ACTION_MODE__TOGGLE || mode == QUICK_ACTION_MODE__SWIPE;
}

// Gets the quick action mode
+ (NSInteger)quickActionMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"qaMode";    
    
    // Get the result
    NSInteger retrievedValue = [defaults integerForKey:key];
    
    return retrievedValue;
}

// Gets the quick action mode
+ (void)setQuickActionMode:(NSInteger)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"qaMode";
    
    // set the value
    [defaults setInteger:mode forKey:key];
    
    // save it
    [defaults synchronize];    
}

// Gets the address to connect to
+ (NSString *)getTargetAddress:(Boolean) includeProtocol {
    if([self useLive]) {
        if(includeProtocol)
            return @"http://live.switchking.se";
        else
            return @"live.switchking.se";
    }
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetAddress";
    
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:key];
    
    if(retrievedValue == nil) {
        if(includeProtocol)
            return @"http://live.switchking.se";
        else
            return @"live.switchking.se";
    }
    
    NSString *finalString;
    
    if(!includeProtocol) {
        NSRange range = [retrievedValue rangeOfString:@"//"];
    
        // Did we find the string "//" ?
        if (range.length > 0)
            finalString = [retrievedValue substringFromIndex:range.location+range.length];
        else
            finalString = retrievedValue;
        
        return finalString;
    }
    
    return retrievedValue;
}

// Sets the address to connect to
+ (void)setTargetAddress:(NSString *) targetAddress:(Boolean) adjustAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"targetAddress";
    
    if(adjustAddress) {
        NSRange range = [targetAddress rangeOfString:@"//"];
        
        // Did we find the string "//" ?
        if(range.length == 0)
            targetAddress = [NSString stringWithFormat:@"http://%@", targetAddress];
    }
    
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

// Gets the server identity
+ (NSString *)getServerIdentity {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"serverIdentity";
    
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:key];
    
    if(retrievedValue == NULL)
        return @"";
    
    return retrievedValue;
}

// Sets the server identity
+ (void)setServerIdentity:(NSString *) serverIdentity {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"serverIdentity";
    
    // set the value
    [defaults setObject:serverIdentity forKey:key];
    
    // save it
    [defaults synchronize]; 
}

// Gets the stored authentication data
+ (AuthenticationDataContainer *)getAuthenticationData {
    AuthenticationDataContainer *container = [[AuthenticationDataContainer alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey = @"user";
    NSString *passKey = @"pass";
    
    // Get the result
    NSString *retrievedUserValue = [defaults stringForKey:userKey];
    NSString *retrievedPassValue = [defaults stringForKey:passKey];
    
    if(retrievedUserValue == nil || [retrievedUserValue isEqualToString:@""])
        retrievedUserValue = @"user";
    
    if(retrievedPassValue == nil || [retrievedPassValue isEqualToString:@""])
        retrievedPassValue = @"pass";
    
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
    
    // Clear...
    [SettingsMgr clearDeviceGroupExpansionData];
}

// Gets the number of seconds to wait before requesting update of device state
// after an action has been requested.
+ (NSTimeInterval)getDeviceUpdateDelay {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"refrAfterActionInterval";
    
    // Get the result
    NSInteger retrievedValue = [defaults integerForKey:key];
    
    if(retrievedValue == 0)
        return 3;
    
    return retrievedValue; 
}

// Sets the number of seconds to wait before requesting update of device state
// after an action has been requested.
+ (void)setDeviceUpdateDelay:(NSTimeInterval) interval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"refrAfterActionInterval";
    
    // set the value
    [defaults setInteger:interval forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets the number of seconds to wait before requesting update of device group state
// after an action has been requested.
+ (NSTimeInterval)getDeviceGroupUpdateDelay {
    return [SettingsMgr getDeviceUpdateDelay] * 2.5;
}

// Gets the refresh interval
+ (NSTimeInterval)getRefreshInterval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"refrInterval";
    
    // Get the result
    NSInteger retrievedValue = [defaults integerForKey:key];
    
    if(retrievedValue == 0)
        return 30;
    
    return retrievedValue; 
}

// Sets the refreshInterval
+ (void)setRefreshInterval:(NSTimeInterval) interval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"refrInterval";
    
    // set the value
    [defaults setInteger:interval forKey:key];
    
    // save it
    [defaults synchronize]; 
}

// Gets the maximum number of upcoming events
+ (NSInteger)getMaxUpcomingEvents {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"maxUpcomingEvents";
    
    // Get the result
    NSInteger retrievedValue = [defaults integerForKey:key];
    
    if(retrievedValue == 0)
        return 10;
    
    return retrievedValue;
}

// Sets the maximum number of upcoming events
+ (void)setMaxUpcomingEvents:(NSInteger) maxUpcomingEvents {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"maxUpcomingEvents";
    
    // set the value
    [defaults setInteger:maxUpcomingEvents forKey:key];
    
    // save it
    [defaults synchronize]; 
}

// Indicates whether a device group is expanded or not
+ (Boolean)deviceGroupIsExpanded:(NSInteger)groupId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"collapsedGroups";
    
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:key];
    
    if(retrievedValue == nil || [@"" isEqualToString:retrievedValue])
        return true;
    
    NSRange r = [retrievedValue rangeOfString:[NSString stringWithFormat:@",%i,", groupId]];
    
    if(r.location == NSNotFound)
        return true;
    else        
        return false;
}

// Sets a device group to expanded or not
+ (void)setDeviceGroupExpanded:(NSInteger)groupId: (Boolean)expanded {
    Boolean currentlyExpanded = [SettingsMgr deviceGroupIsExpanded:groupId];
    
    if(expanded && currentlyExpanded)
        return;
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = @"collapsedGroups";
        
        // Get the result
        NSString *retrievedValue = [defaults stringForKey:key];
        
        if(retrievedValue == nil)
            retrievedValue = @"";
        
        if(expanded && !currentlyExpanded) {
            retrievedValue = [retrievedValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%i,", groupId] withString:@","];
        } else if((expanded && currentlyExpanded) || (!expanded && !currentlyExpanded)) {
            // Do nothing
        } else if(!expanded && currentlyExpanded) {
            if([@"" isEqualToString:retrievedValue])
                retrievedValue = [NSString stringWithFormat:@"%@,%i,", retrievedValue, groupId];
            else
                retrievedValue = [NSString stringWithFormat:@"%@%i,", retrievedValue, groupId];
        }
        
        // set the value
        [defaults setObject:retrievedValue forKey:key];
        
        // save it
        [defaults synchronize]; 
    }
}

// Clears expansion data
+ (void)clearDeviceGroupExpansionData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"collapsedGroups";
    
    // set the value
    [defaults setObject:@"" forKey:key];
    
    // save it
    [defaults synchronize];
}


// Toggles expansion
+ (void)toggleDeviceGroupExpanded:(NSInteger)groupId {
    [SettingsMgr setDeviceGroupExpanded:groupId :![SettingsMgr deviceGroupIsExpanded:groupId]];
}

// Indicates whether scenario list needs refresh
+ (void)setScenarioListRefreshNeeded:(Boolean)refreshOfScenarioListNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"scenarioRefr";
    
    // set the value
    [defaults setBool:refreshOfScenarioListNeeded forKey:key];
    
    // save it
    [defaults synchronize];
}

// Indicates whether a full refresh of scenario list is needed
+ (Boolean)scenarioListRefreshNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"scenarioRefr";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Indicates whether historic events are supported
+ (void)setSupportsHistoricEvents:(Boolean)supportsHistoricEvents {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"histEvt";
    
    // set the value
    [defaults setBool:supportsHistoricEvents forKey:key];
    
    // save it
    [defaults synchronize];
}

// Indicates whether historic events are supported
+ (Boolean)supportsHistoricEvents; {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"histEvt";    
    
    // Get the result
    Boolean retrievedValue = [defaults boolForKey:key];
    
    return retrievedValue;
}

// Sets the server version
+ (void)setServerVersion:(NSString *)serverVersion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"serverVer";
    
    NSLog(@"Server Version: %@", serverVersion);
    
    // set the value
    [defaults setObject:serverVersion forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets the server version
+ (NSString *)getServerVersion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"serverVer";
    
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:key];

    return retrievedValue;
}

// Sets an indication whether it's necessary to indicate days left for live usage
+ (void)setNextDateWhenNeedToDisplayDaysLeftForLive:(NSDate *)nextCheck {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"nextLiveInfoDate";
    
    // set the value
    [defaults setObject:nextCheck forKey:key];
    
    // save it
    [defaults synchronize];
}

// Gets an indication whether it's necessary to indicate days left for live usage
+ (Boolean)needToDisplayDaysLeftForLive {
    if(![SettingsMgr useLive])
        return false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"nextLiveInfoDate";
    
    // Get the result
    NSDate *retrievedValue = (NSDate *)[defaults objectForKey:key];
    
    if(retrievedValue == nil)
        return true;
    
	NSDate *today = [[NSDate alloc] init];
    NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    [cal setTimeZone:defaultTimeZone];
    
    NSTimeInterval time = [today timeIntervalSinceDate:retrievedValue];
    
    return time > 0;
}

@end
