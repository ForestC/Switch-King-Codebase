//
//  EntityStore.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"
#import "SKEntity.h"
#import "SKDevice.h"
#import "DeviceListViewController.h"

@implementation EntityStore
{
    NSMutableArray * deviceList;
}

@synthesize deviceListViewController;

- (void)entityUpdated:(NSObject *) src : (SKEntity *) entity {
    if([entity isKindOfClass:[SKDevice class]]) {
        
    }
    
    NSLog(@"Updated id value :%i", entity.ID);
}

- (void)entityCollectionUpdated:(NSObject *) src:(NSMutableArray *) collection:(Class) entityClass {
    if([entityClass class] == [SKDevice class]){
        [self devicesUpdated:collection];
    }    
}

- (void)devicesUpdated:(NSMutableArray *)collection {
    deviceList = collection;
    /*
	UITabBarController *tabBarController = 
    (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController = 
    [[tabBarController viewControllers] objectAtIndex:0];
	DeviceListViewController *deviceListViewController = 
    [[navigationController viewControllers] objectAtIndex:0];*/
	//deviceListViewController.devices = deviceList;
    
    // Send a dictionary with devices to the receivers...
    NSDictionary * orientationData;
    orientationData = [NSDictionary dictionaryWithObject:collection
                                                  forKey:@"Devices"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"DevicesUpdated"
                                      object:nil
                                    userInfo:orientationData];
    
}

@end
