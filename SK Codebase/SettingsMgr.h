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

// Registers defaults
+ (void)initDefaults;

// Gets an indication whether settings are configured or not
+ (Boolean)initialSettingsConfigured;

// Sets an indication whether settings are configured or not
+ (void)setInitialSettingsConfigured:(Boolean) configured;

// Gets an indication whether server version needs update
+ (Boolean)needServerVersionUpdate;

// Sets an indication whether server version needs update
+ (void)setNeedServerVersionUpdate:(Boolean) needServerVersionUpdate;

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
+ (NSString *)getServerIdentity;

// Sets the server identity
+ (void)setServerIdentity:(NSString *) serverIdentity;

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

// Gets an indication whether to group data sources or not
+ (Boolean)groupDataSources;

// Sets an indication whether to group data sources or not
+ (void)setGroupDataSources:(Boolean) groupDataSources;

// Gets an indication whether to enable learn button or not
+ (Boolean)showLearnButton;

// Sets an indication whether to enable learn button or not
+ (void)setShowLearnButton:(Boolean) enableLearnButton;

// Gets an indication whether to reload views on tab switch or not
+ (Boolean)enableReloadOnTabSwitch;

// Sets an indication whether to reload views on tab switch or not
+ (void)setEnableReloadOnTabSwitch:(Boolean) enableReloadOnTabSwitch;

// Gets an indication whether swipe on device list is enabled or not
+ (Boolean)deviceListSwipeEnabled;

// Gets an indication whether swipe on device list is enabled or not
+ (Boolean)deviceListToggleEnabled;

// Gets the quick action mode
+ (NSInteger)quickActionMode;

// Gets the quick action mode
+ (void)setQuickActionMode:(NSInteger)mode;

// Gets the refresh interval
+ (NSTimeInterval)getRefreshInterval;

// Sets the refreshInterval
+ (void)setRefreshInterval:(NSTimeInterval) interval;

// Gets the maximum number of upcoming events
+ (NSInteger)getMaxUpcomingEvents;

// Sets the maximum number of upcoming events
+ (void)setMaxUpcomingEvents:(NSInteger) maxUpcomingEvents;

// Indicates whether a device group is expanded or not
+ (Boolean)deviceGroupIsExpanded:(NSInteger)groupId;

// Sets a device group to expanded or not
+ (void)setDeviceGroupExpanded:(NSInteger)groupId: (Boolean)expanded;

// Clears expansion data
+ (void)clearDeviceGroupExpansionData;

// Toggles expansion
+ (void)toggleDeviceGroupExpanded:(NSInteger)groupId;

// Indicates whether scenario list needs refresh
+ (void)setScenarioListRefreshNeeded:(Boolean)refreshOfScenarioListNeeded;

// Indicates whether a full refresh of scenario list is needed
+ (Boolean)scenarioListRefreshNeeded;

// Indicates whether historic events are supported
+ (void)setSupportsHistoricEvents:(Boolean)supportsHistoricEvents;

// Indicates whether historic events are supported
+ (Boolean)supportsHistoricEvents;

// Indicates whether system modes are supported
+ (void)setSupportsSystemModes:(Boolean)supportsSystemModes;

// Indicates whether system modes are supported
+ (Boolean)supportsSystemModes;

// Sets the server version
+ (void)setServerVersion:(NSString *)erverVersion;

// Gets the server version
+ (NSString *)getServerVersion;

// Sets an indication whether it's necessary to indicate days left for live usage
+ (void)setNextDateWhenNeedToDisplayDaysLeftForLive:(NSDate *)nextCheck;

// Gets an indication whether it's necessary to indicate days left for live usage
+ (Boolean)needToDisplayDaysLeftForLive;

@end
