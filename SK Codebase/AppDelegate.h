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
#import "AlertInfoViewController.h"
#import "SwipeInfoViewController.h"
#import "SKTabBarControllerDelegate_iPhone.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, EntityActionRequestDelegate> {
    NSInteger netActivityReqs;
    Boolean alertInfoInView;
    NSString *alertInfoText;
    AlertInfoViewController *alertInfoViewController;
    SwipeInfoViewController *swipeViewController;
    NSTimer *alertTimer;
    SKTabBarControllerDelegate_iPhone *tabBarDelegate;
    Boolean swipeInfoIsInView;
}

// Configures the entity view controllers
- (void)configureEntityViewControllers;

// Fired when an entity action request is fired.
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req;

// Requests display of network activity indicator
- (void)requestNetworkActivityIndicator;

// Requests hiding of network activity indicator
- (void)releaseNetworkActivityIndicator;

// Sets the alert info text
- (void)setAlertInfo:(NSString *)infoText;

// Sets the alert info as visible or hidden
- (void)toggleAlertInfo:(BOOL)viewHidden;

// Hides the alert info
- (void)hideAlertInfo;

- (void)setSwipeInfoData:(NSString *)text:(NSInteger)action:(Boolean)supportsDim:(NSInteger)dimLevel;

- (void)toggleSwipeInfo:(BOOL)viewHidden:(CGRect)viewFrame;

/*******************************************************************************
 Notification Methods
 *******************************************************************************/

// Adds entity observers to be able to listen to notifications
- (void)addObservers;

// Called when a request for alert info display is sent
- (void)alertInfoDisplayRequested:(NSNotification *)notification;


@property (strong, nonatomic) UIWindow *window;
@property (retain) EntityStore *entityStore;
@property (retain) CommunicationMgr *communicationMgr;
@property (retain) NSString *alertInfoText;
@property (assign) Boolean alertInfoInView;
@property (nonatomic, retain) NSTimer *alertTimer;

@end
