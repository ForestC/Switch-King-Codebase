//
//  SKEventDataReceiver.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"
#import "DataReceivedDelegate.h"
#import "SKDataReceiver.h"

@interface SKEventDataReceiver : SKDataReceiver <DataReceivedDelegate>

@end