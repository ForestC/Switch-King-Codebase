//
//  SKDataSourceDataReceiver.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"
#import "DataReceivedDelegate.h"
#import "SKDataReceiver.h"

@interface SKDataSourceDataReceiver : SKDataReceiver <DataReceivedDelegate>

@end