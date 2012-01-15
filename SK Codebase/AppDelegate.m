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

@implementation AppDelegate

@synthesize window = _window;
@synthesize entityStore;
@synthesize communicationMgr;

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

- (void)toggleOptions:(BOOL)ViewHidden
{
    // this method opens/closes the player options view (which sets repeat interval, repeat & delay on/off)
    
    if (ViewHidden == NO)
    {
        // delay and move view out of superview
        CGRect optionsFrame = optionsController.view.frame;
        
        [UIView beginAnimations:nil context:nil];
        
        optionsFrame.origin.y += optionsFrame.size.height;
        optionsController.view.frame = optionsFrame;
        
        [UIView commitAnimations];
        
        [optionsController.view
         performSelector:@selector(removeFromSuperview)
         withObject:nil
         afterDelay:0.5];
        [optionsController
         performSelector:@selector(release)
         withObject:nil
         afterDelay:0.5];
        optionsController = nil;
    }
    else
    {
        optionsController = [[PlayOptionsViewController alloc] init];
        
        //
        // Position the options at bottom of screen
        //
        CGRect optionsFrame = optionsController.view.frame;
        optionsFrame.origin.x = 0;
        optionsFrame.size.width = 320;
        optionsFrame.origin.y = 423;
        
        //
        // For the animation, move the view up by its own height.
        //
        optionsFrame.origin.y += optionsFrame.size.height;
        
        optionsController.view.frame = optionsFrame;
        [window addSubview:optionsController.view];
        
        [UIView beginAnimations:nil context:nil];
        
        optionsFrame.origin.y -= optionsFrame.size.height;
        optionsController.view.frame = optionsFrame;
        
        [UIView commitAnimations];
    }
}


@end
