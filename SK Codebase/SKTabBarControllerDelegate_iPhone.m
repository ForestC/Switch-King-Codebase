//
//  SKTabBarControllerDelegate_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKTabBarControllerDelegate_iPhone.h"

@implementation SKTabBarControllerDelegate_iPhone

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    
    [nav popToRootViewControllerAnimated:false];
}

@end
