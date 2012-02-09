//
//  SKNavigationControllerDelegate_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKNavigationControllerDelegate_iPhone.h"
#import "DeviceListViewController.h"

@implementation SKNavigationControllerDelegate_iPhone

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if([viewController isKindOfClass:[DeviceListViewController class]]) {
        NSLog(@"CONTROLLER");
    }
    
}

@end
