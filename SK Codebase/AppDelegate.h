//
//  AppDelegate.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityStore.h"
#import "CommunicationMgr.h"
#import "EntityActionRequestDelegate.h"
#import "MessageViewController.h"
#import "SwipeInfoViewController.h"
#import "SKTabBarControllerDelegate_iPhone.h"
//#import "MessageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, EntityActionRequestDelegate> {
    NSInteger netActivityReqs;

    // Indicates whether alert view is visible
    Boolean alertViewInView;
    // Holds the message text
//    NSString *alertMessageText;
    // Holds the controller
    UIViewController *alertMessageViewController;
    
    SwipeInfoViewController *swipeViewController;
    NSTimer *alertTimer;
    NSTimer *refreshTimer;
    SKTabBarControllerDelegate_iPhone *tabBarDelegate;
    Boolean swipeInfoIsInView;
    CGRect originalAlertFrame;
}

// Fired when an entity action request is fired.
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req;

// Requests display of network activity indicator
- (void)requestNetworkActivityIndicator;

// Requests hiding of network activity indicator
- (void)releaseNetworkActivityIndicator;

// Sets the alert info text
- (void)setAlertInfo:(NSString *)infoText;

// Gets the alert string currently displayed
- (NSString *)getAlertInfo;

// Gets the alert string currently displayed
- (Boolean)eligableForAlertInfoDisplay:(NSString *)str;

// Sets the alert info as visible or hidden
- (void)toggleAlertInfo:(BOOL) show:(NSString *)alertInfoType;

// Hides the alert info
- (void)hideAlertInfo;

- (void)setSwipeInfoData:(NSString *)text:(NSInteger)action:(Boolean)supportsDim:(NSInteger)dimLevel;

- (void)toggleSwipeInfo:(BOOL)viewHidden:(CGRect)viewFrame;

// Cancels the refresh timer
- (void)cancelRefreshTimer;

// Resumes refresh timer
- (void)resumeRefreshTimer;


/*******************************************************************************
 Notification Methods
 *******************************************************************************/

// Adds entity observers to be able to listen to notifications
- (void)addObservers;

// Called when a request for alert info display is sent
- (void)alertInfoDisplayRequested:(NSNotification *)notification;


@property (strong, nonatomic) UIWindow *window;
@property (strong) EntityStore *entityStore;
@property (strong) CommunicationMgr *communicationMgr;
@property (nonatomic, copy) NSString *alertInfoText;
@property (nonatomic, assign) Boolean alertInfoInView;
@property (nonatomic, retain) NSTimer *alertTimer;
@property (nonatomic, retain) NSTimer *refreshTimer;

@end
