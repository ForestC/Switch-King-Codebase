//
//  SettingsStore.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationDataContainer.h"

@interface SettingsMgr : NSObject

// Gets an indication whether settings are configured or not
+ (Boolean)initialSettingsConfigured;

// Sets an indication whether settings are configured or not
+ (void)setInitialSettingsConfigured:(Boolean) configured;

// Gets an indication whether settings are configured or not
+ (Boolean)settingsConfigured;

// Sets an indication whether settings are configured or not
+ (void)setSettingsConfigured:(Boolean) configured;

// Gets an indication whether to use live or not
+ (Boolean)useLive;

// Sets an indication whether to use live or not
+ (void)setUseLive:(Boolean) useLive;

// Gets the address to connect to
+ (NSString *)getTargetAddress:(Boolean) includeProtocol;

// Sets the address to connect to
+ (void)setTargetAddress:(NSString *) targetAddress:(Boolean) adjustAddress;

// Gets the port to connect to
+ (NSInteger)getTargetPort;

// Sets the port to connect to
+ (void)setTargetPort:(NSInteger) targetPort;

// Gets the server identity
+ (NSInteger)getServerIdentity;

// Sets the server identity
+ (void)setServerIdentity:(NSInteger) serverIdentity;

// Gets the stored authentication data
+ (AuthenticationDataContainer *)getAuthenticationData;

// Sets the authentication data
+ (void)setAuthenticationData:(AuthenticationDataContainer *) data;

// Gets the number of seconds to wait before requesting update of device state
// after an action has been requested.
+ (NSTimeInterval)getDeviceUpdateDelay;

// Sets the number of seconds to wait before requesting update of device state
// after an action has been requested.
+ (void)setDeviceUpdateDelay:(NSTimeInterval) interval;

// Gets the number of seconds to wait before requesting update of device group state
// after an action has been requested.
+ (NSTimeInterval)getDeviceGroupUpdateDelay;

// Gets an indication whether to group devices or not
+ (Boolean)groupDevices;

// Sets an indication whether to group devices or not
+ (void)setGroupDevices:(Boolean) groupDevices;

// Gets an indication whether to enable learn button or not
+ (Boolean)showLearnButton;

// Sets an indication whether to enable learn button or not
+ (void)setShowLearnButton:(Boolean) enableLearnButton;

// Gets an indication whether to reload views on tab switch or not
+ (Boolean)enableReloadOnTabSwitch;

// Sets an indication whether to reload views on tab switch or not
+ (void)setEnableReloadOnTabSwitch:(Boolean) enableReloadOnTabSwitch;

// Gets the refresh interval
+ (NSTimeInterval)getRefreshInterval;

// Sets the refreshInterval
+ (void)setRefreshInterval:(NSTimeInterval) interval;

// Gets the maximum number of upcoming events
+ (NSInteger)getMaxUpcomingEvents;

// Sets the maximum number of upcoming events
+ (void)setMaxUpcomingEvents:(NSInteger) maxUpcomingEvents;

@end
