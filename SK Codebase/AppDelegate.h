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

@interface AppDelegate : UIResponder <UIApplicationDelegate, EntityActionRequestDelegate>

// Configures the entity view controllers
- (void)configureEntityViewControllers;

// Fired when an entity action request is fired.
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req;

@property (strong, nonatomic) UIWindow *window;
@property (retain) EntityStore *entityStore;
@property (retain) CommunicationMgr *communicationMgr;

@end
