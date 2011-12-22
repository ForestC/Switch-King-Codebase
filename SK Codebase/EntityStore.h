//
//  EntityStore.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDeviceStoreDelegate.h"
#import "DeviceListViewController.h"

@interface EntityStore : NSObject <SKDeviceStoreDelegate> {
    
}

@property (nonatomic, strong) DeviceListViewController *deviceListViewController;

- (void)devicesUpdated:(NSMutableArray *) collection;

@end
