//
//  AppDelegate.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SKDeviceDataReceiver.h"
#import "DeviceListViewController.h"
#import "CommunicationMgr.h"
#import "SettingsMgr.h"
#import <objc/runtime.h>
#include "Constants.h"
#import "TextHelper.h"
#import "SettingsListViewController_iPhone.h"
#import "ServerSettingsListViewController_iPhone.h"
#import "SKTabBarControllerDelegate_iPhone.h"
#import "SKNavigationControllerDelegate_iPhone.h"
#import "AlertMessageView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize entityStore;
@synthesize communicationMgr;
@synthesize alertInfoInView;
@synthesize alertInfoText;
@synthesize alertTimer;
@synthesize refreshTimer;

// Called when an entity action request has been fired
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req {
    [communicationMgr requestEntityAction:req]; 
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init user defaults
    [SettingsMgr initDefaults];
    
    // Adds observers for alerts etc.
    [self addObservers];
    
    // Init the alert info view controller
    alertMessageViewController = [[UIViewController alloc] initWithNibName:@"AlertMessageView" 
                                                                 bundle:[NSBundle mainBundle]];
    
    originalAlertFrame = alertMessageViewController.view.frame;
    
    swipeViewController = [[SwipeInfoViewController alloc] init];
    
    UITabBarController *v2 = (UITabBarController*)self.window.rootViewController;
    tabBarDelegate = [[SKTabBarControllerDelegate_iPhone alloc] init];
    v2.delegate = tabBarDelegate;
   
    // Create the entity store...
    entityStore = [[EntityStore alloc] init];
    // Create the communication manager...
    communicationMgr = [[CommunicationMgr alloc] init];
    // Request update of all entities...
    [communicationMgr requestUpdateOfAllEntities];
    // Request update of Live days left
    if([SettingsMgr needToDisplayDaysLeftForLive]) {
        [communicationMgr requestUpdateOfLiveDaysLeft];
    }
    
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

    @try {
        //CancelRefreshTimer ();
        
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navController = (UINavigationController*)[tabController selectedViewController];

        if (navController != nil) {            
            if(
               ![navController.visibleViewController isKindOfClass:[ServerSettingsListViewController_iPhone class]] &&
               ![navController.visibleViewController isKindOfClass:[SettingsListViewController_iPhone class]]) {
                
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                
                EntityHttpReqNotificationData *reqNotificationData = [EntityHttpReqNotificationData alloc];
                
                reqNotificationData.entityType = ENTITY_TYPE__ALL_ENTITIES;
                
                NSDictionary *notificationData = [NSDictionary dictionaryWithObject:reqNotificationData 
                                                                             forKey:ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY];
                [notificationCenter postNotificationName:NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING
                                                  object:nil
                                                userInfo:notificationData];                    
                
                [navController popViewControllerAnimated:false];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [self.communicationMgr requestUpdateOfAllEntities];
    
    // Request update of Live days left
    if([SettingsMgr needToDisplayDaysLeftForLive]) {
        [communicationMgr requestUpdateOfLiveDaysLeft];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
   // [self.communicationMgr requestUpdateOfAllEntities];
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
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(alertInfoDisplayRequested:)
                               name:NOTIFICATION_NAME__ALERT_INFO_REQUESTED
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(serverVersionUpdated)
                               name:NOTIFICATION_NAME__SERVER_VERSION_UPDATED
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(liveDaysLeftUpdated:)
                               name:NOTIFICATION_NAME__LIVE_DAYS_LEFT_UPDATED
                             object:nil];

}

// Called when days left of live usage has been updated
- (void)liveDaysLeftUpdated:(NSNotification *)daysLeftNotification {
    NSString *localized = NSLocalizedStringFromTable(@"Your license for Switch King Live will expire in %@ day(s).", @"Texts", nil);
    NSNumber *daysLeft = [daysLeftNotification.userInfo objectForKey:@"LiveDaysLeft"];
    localized = [NSString stringWithFormat:localized, [daysLeft stringValue]];

    NSDictionary *notificationData = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localized, ALERT_INFO_NOTIFICATION__ALERT_MSG_KEY,
                                   ALERT_INFO_TYPE__CHIME, ALERT_INFO_TYPE,
                                   nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME__ALERT_INFO_REQUESTED
                                                        object:nil
                                                      userInfo:notificationData];
}

// Called after server version has been updated
- (void)serverVersionUpdated {
    [self.communicationMgr requestUpdateOfAllEntities];
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
        // The alert info type
        NSString *alertInfoType = [dict valueForKey:ALERT_INFO_TYPE];
        
        if(alertData != nil) {
            if([self eligableForAlertInfoDisplay:alertData]) {
                [self setAlertInfo:alertData];
                [self toggleAlertInfo:true
                                     :alertInfoType];
            }
        } else {
            NSLog(@"Empty alert.");
        }
    }  
}

/*******************************************************************************
 Swipe Info View
 *******************************************************************************/


- (void)setSwipeInfoData:(NSString *)text:(NSInteger)action:(Boolean)supportsDim:(NSInteger)dimLevel {
    swipeViewController.swipeInfoLabel.text = text;
    
    if(action == ACTION_ID__CANCEL) {
         swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:@"SwipeCancel"]; 
    }
    else if(supportsDim) {
        if(action == ACTION_ID__TURN_OFF) {
            swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:@"SwipeDimOff"]; 
        } else if(action == ACTION_ID__TURN_ON && dimLevel == 100) {
            swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:@"SwipeDimOn"]; 
        } else {
            swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SwipeDim%i", dimLevel]]; 
        }
    } else {
        if(action == ACTION_ID__TURN_ON) {
            swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:@"SwipeOn"]; 
        } else {
            swipeViewController.swipeInfoImageView.image = [UIImage imageNamed:@"SwipeOff"]; 
        }
    }
}

// Hides the alert info
- (void)hideSwipeInfo {
    [swipeViewController.view removeFromSuperview];
}

// Sets the alert info as visible or hidden
- (void)toggleSwipeInfo:(BOOL)viewHidden:(CGRect)viewFrame
{
    // this method opens/closes the player options view (which sets repeat interval, repeat & delay on/off)    
    if (viewHidden == NO)
    {
        [UIView beginAnimations:nil context:NULL]; 
        [UIView setAnimationDuration:0.5]; 
        [swipeViewController.view setAlpha:0.0]; 
        [UIView commitAnimations]; 
        
        [self 
         performSelector:@selector(hideSwipeInfo)
         withObject:nil
         afterDelay:0.5];
        
        
        swipeInfoIsInView = false;
    }
    else if(!swipeInfoIsInView)
    {
        swipeInfoIsInView = true;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        Boolean portrait = orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth;
        CGFloat screenHeight;
        
        if(portrait) {
            screenWidth=  screenRect.size.width;
            screenHeight = screenRect.size.height;            
        } else {
            screenWidth=  screenRect.size.height;
            screenHeight = screenRect.size.width;
        }
        
        CGRect alertFrame = swipeViewController.view.frame;
        alertFrame.origin.x = screenWidth / 2 - (alertFrame.size.width/2);
        
        if(viewFrame.origin.y > (screenHeight /5)) {
            alertFrame.origin.y = viewFrame.origin.y - (alertFrame.size.height / 2); // (screenHeight /3) - (alertFrame.size.height/2);// - h;
        } else {
            alertFrame.origin.y = viewFrame.origin.y + viewFrame.size.height + (alertFrame.size.height) - (alertFrame.size.height/4);
        }
        
        swipeViewController.view.frame = alertFrame;
        
        [self.window.rootViewController.view addSubview:swipeViewController.view];
        
        [swipeViewController.view setAlpha:0.0]; 
        
        [UIView beginAnimations:nil context:NULL]; 
        [UIView setAnimationDuration:0.5]; 
        [swipeViewController.view setAlpha:1.0]; 
        
        [UIView commitAnimations];
    }
}

/*******************************************************************************
 Refresh Timer
 *******************************************************************************/

// Cancels refresh timer
- (void)cancelRefreshTimer {
    if(refreshTimer != nil) {
        [refreshTimer invalidate];
        refreshTimer = nil;
    }
}

// Resumes refresh timer
- (void)resumeRefreshTimer {
    [self cancelRefreshTimer];
    
    if([SettingsMgr getRefreshInterval] == AUTOMATIC_REFRESH__TURNED_OFF)
        return;
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval: [SettingsMgr getRefreshInterval] 
                                                    target:self 
                                                  selector:@selector(refreshTimerOnTick:) 
                                                  userInfo:nil 
                                                   repeats:YES];
}

// Triggered when automatic refresh is requested
- (void)refreshTimerOnTick:(NSTimer *)theTimer {
    [communicationMgr requestUpdateOfAllEntities];
}

/*******************************************************************************
 Alert Info View
 *******************************************************************************/

// Sets the alert info as visible or hidden
- (void)toggleAlertInfo:(BOOL) show:(NSString *)alertInfoType
{
    // this method opens/closes the player options view (which sets repeat interval, repeat & delay on/off)    
    if (show == NO)
    {
        [UIView beginAnimations:nil context:NULL]; 
        [UIView setAnimationDuration:0.5]; 
        [alertMessageViewController.view setAlpha:0.0]; 
        [UIView commitAnimations]; 

        [self 
         performSelector:@selector(hideAlertInfo)
         withObject:nil
         afterDelay:0.5];
    }
    else
    {
        alertInfoInView = true;
        
        AlertMessageView *v = (AlertMessageView *)(alertMessageViewController.view);
        
        if(![ALERT_INFO_TYPE__CHIME isEqualToString:alertInfoType]) {
            v.infoImageView.image = [UIImage imageNamed:@"InfoWarning"];
        } else {
            v.infoImageView.image = [UIImage imageNamed:@"InfoChime"];
        }
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        Boolean portrait = orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth;
        CGFloat screenHeight;
        
        if(portrait) {
            screenWidth = screenRect.size.width;
            screenHeight = screenRect.size.height;            
        } else {
            screenWidth = screenRect.size.height;
            screenHeight = screenRect.size.width;
        }
        
        CGRect alertFrame = originalAlertFrame;//alertMessageViewController.view.frame;
        
        alertFrame.origin.x = screenWidth / 2 - (alertFrame.size.width/2);
        alertFrame.origin.y = screenHeight - 60 - alertFrame.size.height;
        
        alertMessageViewController.view.frame = alertFrame;
        
        [alertMessageViewController.view setNeedsLayout];
        
        [self.window.rootViewController.view addSubview:alertMessageViewController.view];
        
        [alertMessageViewController.view setAlpha:0.0]; 
        
        [UIView beginAnimations:nil context:NULL]; 
        [UIView setAnimationDuration:0.5]; 
        [alertMessageViewController.view setAlpha:1.0]; 
        
        [UIView commitAnimations];

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
    [alertMessageViewController.view removeFromSuperview];
    
    [self setAlertInfoInView:false];
}

// Sets the alert info text
- (void)setAlertInfo:(NSString *)infoText {
    AlertMessageView *v = (AlertMessageView *)(alertMessageViewController.view);
    [[v infoTextView] setText:infoText];
}
        
// Gets the alert string currently displayed
- (NSString *)getAlertInfo {
    AlertMessageView *v = (AlertMessageView *)(alertMessageViewController.view);
    return v.infoTextView.text;
}

// Gets the alert string currently displayed
- (Boolean)eligableForAlertInfoDisplay:(NSString *)str {
    if([self alertInfoInView]) {
        return ![str isEqualToString:[self getAlertInfo]];
    } else {
        return true;
    }
}

// Triggered when the alert info view is to be hidden after a specific amount of time.
-(void)alertTimerOnTick:(NSTimer *)theTimer {
    if(alertTimer != nil) {
        [alertTimer invalidate];
        alertTimer = nil;
    }
    
    [self toggleAlertInfo:false
                         :nil];
}

@end
