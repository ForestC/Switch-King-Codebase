//
//  AppDelegate.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CommunicationBase.h"
#import "SKDeviceDataReceiver.h"
#import "DeviceListViewController.h"
#import "CommunicationMgr.h"
#import "SettingsMgr.h"
#import <objc/runtime.h>
#include "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize entityStore;
@synthesize communicationMgr;
@synthesize alertInfoInView;
@synthesize alertInfoText;

// Configures the entity view controllers
- (void)configureEntityViewControllers
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0];

    // The device list view controller...
    DeviceListViewController *deviceListViewController = (DeviceListViewController *)navigationController;
    
    // Connect the device list view controller to the entity stores notification
    [entityStore setDeviceListViewController:deviceListViewController];
}

// Called when an entity action request has been fired
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req {
    [communicationMgr requestEntityAction:req]; 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Adds observers for alerts etc.
    [self addObservers];
    
    // Init the alert info view controller
    alertInfoViewController = [[AlertInfoViewController alloc] init];
    
    AuthenticationDataContainer * auth = [SettingsMgr getAuthenticationData];
    
    auth = [AuthenticationDataContainer alloc];
    
    //auth.user = @"user";
    //auth.pass = @"pass";
    
    auth.user = @"user";
    auth.pass = @"pass";
    
    [SettingsMgr setAuthenticationData:auth];
    [SettingsMgr setTargetAddress:@"http://www.switchking.se":false];
    [SettingsMgr setTargetPort:10800];
    
    // Create the entity store...
    entityStore = [[EntityStore alloc] init];
    // Create the communication manager...
    communicationMgr = [[CommunicationMgr alloc] init];
    // Request update of all entities...
    [communicationMgr requestUpdateOfAllEntities];
    
       //CommunicationBase * communicationBase = [[CommunicationBase alloc] initWithAuthenticationData:auth];
    //SKDeviceDataReceiver * receiver = [SKDeviceDataReceiver alloc];
    
   // [receiver setEntityStore:entityStore];
 //   [communicationBase setReceiverDelegate:receiver];
//    [communicationBase sendRequest:@"http://www.switchking.se:10800/devices"];
//    
//    AuthenticationDataContainer * auth = [AuthenticationDataContainer alloc];
//    
//    [auth setUser:@"user"];
//    [auth setPass:@"pass"];
//    
//    CommunicationBase * b = [[CommunicationBase alloc] initWithAuthenticationData:auth];
//    SKDeviceDataReceiver * r = [SKDeviceDataReceiver alloc];
//    
//    
//    [r setEntityStore:entityStore];
//    [b setReceiverDelegate:r];
//    [b sendRequest:@"http://www.switchking.se:10800/devices"];
//
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*******************************************************************************
 Network Activity Indicator
 *******************************************************************************/

// Requests display of network activity indicator
- (void)requestNetworkActivityIndicator {
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
    
	self->netActivityReqs++;
}

// Requests hiding of network activity indicator
- (void)releaseNetworkActivityIndicator {
    
	self->netActivityReqs--;
	if(self->netActivityReqs <= 0)
	{
		UIApplication* app = [UIApplication sharedApplication];
		app.networkActivityIndicatorVisible = NO;
	}
    
	//failsafe
	if(self->netActivityReqs < 0)
		self->netActivityReqs = 0;
}

/*******************************************************************************
 Notification Methods
 *******************************************************************************/

// Adds entity observers to be able to listen to notifications
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alertInfoDisplayRequested:)
                                                 name:NOTIFICATION_NAME__ALERT_INFO_REQUESTED
                                               object:nil];    
}

// Called when a request for alert info display is sent
- (void)alertInfoDisplayRequested:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__ALERT_INFO_REQUESTED]) {
        // Log
        NSLog (@"AppDelegate received an alert info req");
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        // Get the request data
        NSString *alertData = [dict valueForKey:ALERT_INFO_NOTIFICATION__ALERT_MSG_KEY];
        
        if(alertData != nil) {
            [self setAlertInfo:alertData];
            [self toggleAlertInfo:true];
        } else {
            NSLog(@"Empty alert.");
        }
    }  
}

/*******************************************************************************
 Alert Info View
 *******************************************************************************/

// Sets the alert info as visible or hidden
- (void)toggleAlertInfo:(BOOL)viewHidden
{
    // this method opens/closes the player options view (which sets repeat interval, repeat & delay on/off)    
    if (viewHidden == NO)
    {
        // delay and move view out of superview
        CGRect alertFrame = alertInfoViewController.view.frame;
        
        [UIView beginAnimations:nil context:nil];
        
        alertFrame.origin.y += alertFrame.size.height * 2;
        alertInfoViewController.view.frame = alertFrame;
        
        [UIView commitAnimations];

        [self 
         performSelector:@selector(hideAlertInfo)
         withObject:nil
         afterDelay:0.5];
    }
    else
    {
        UITabBarController *v2 = (UITabBarController*)self.window.rootViewController;
        CGFloat v44 = v2.tabBar.frame.size.height;
        
        //
        // Position the options at bottom of screen
        //
        CGRect alertFrame = alertInfoViewController.view.frame;
        alertFrame.origin.x = 0;
        alertFrame.size.width = 320;
        alertFrame.origin.y = 403 - v44;// - h;
        alertFrame.size.height = 77;
        
        //
        // For the animation, move the view up by its own height.
        //
        alertFrame.origin.y += alertFrame.size.height;
        
        alertInfoViewController.view.frame = alertFrame;
        
        //[v3 addSubview:optionsController.view];
        [self.window.rootViewController.view addSubview:alertInfoViewController.view];
//        [v2 addSubview:optionsController.view];
        
        [UIView beginAnimations:nil context:nil];
        
        alertFrame.origin.y -= alertFrame.size.height;
        alertInfoViewController.view.frame = alertFrame;
        
        [UIView commitAnimations];
        
        alertInfoInView = true;

        if(alertTimer != nil) {
            [alertTimer invalidate];
            alertTimer = nil;
        }
        
        alertTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 
                                                  target:self 
                                                    selector:@selector(alertTimerOnTick:) 
                                                userInfo:nil 
                                                 repeats: NO];
    }
}
         
// Hides the alert info
- (void)hideAlertInfo {
    [alertInfoViewController.view removeFromSuperview];
    
    [self setAlertInfoInView:false];
}

// Sets the alert info text
- (void)setAlertInfo:(NSString *)infoText {
    self.alertInfoText = infoText;
    [[alertInfoViewController infoTextView] setText:infoText];
}

// Triggered when the alert info view is to be hidden after a specific amount of time.
-(void)alertTimerOnTick:(NSTimer *)theTimer {
    if(alertTimer != nil) {
        [alertTimer invalidate];
        alertTimer = nil;
    }
    
    [self toggleAlertInfo:false];
}

@end
