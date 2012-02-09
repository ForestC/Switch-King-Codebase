//
//  SKTabBarControllerDelegate_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKTabBarControllerDelegate_iPhone.h"
#import "AppDelegate.h"
#import "CommunicationMgr.h"
#import "Constants.h"
#import "SettingsMgr.h"

@implementation SKTabBarControllerDelegate_iPhone

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
    
    [nav popToRootViewControllerAnimated:false];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([SettingsMgr enableReloadOnTabSwitch]) {
        switch (tabBarController.selectedIndex) {
            case TAB_INDEX__DEVICES:
                [appDelegate.communicationMgr requestUpdateOfDevices];
                break;
                
            case TAB_INDEX__EVENTS:
                [appDelegate.communicationMgr requestUpdateOfEvents];
                break;            
                
            case TAB_INDEX__SCENARIOS:
                [appDelegate.communicationMgr requestUpdateOfScenarios];
                break;
                
            case TAB_INDEX__DATA_SOURCES:
                [appDelegate.communicationMgr requestUpdateOfDataSources];
                break;
                
            default:
                break;
        }
    }
}

@end
