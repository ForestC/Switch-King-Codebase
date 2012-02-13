//
//  SKDeviceDataReceiver.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataReceivedDelegate.h"
#import "SKDeviceStoreDelegate.h"
#import "EntityStore.h"
#import "SKDataReceiver.h"

@interface SKDeviceDataReceiver : SKDataReceiver <DataReceivedDelegate>

@end
