//
//  SKSystemSettingDataReceiver.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"
#import "DataReceivedDelegate.h"

@interface SKSystemSettingDataReceiver : NSObject <DataReceivedDelegate>
{
    EntityStore * entityStore;
}

@property (retain) EntityStore * entityStore;

@end