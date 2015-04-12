//
//  DeviceListTableView.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceListTableView.h"
#include "Constants.h"

@implementation DeviceListTableView

- (void)awakeFromNib {
   // [super awakeFromNib];
    [self addTableReloadObserver];
   // NSLog(@"AA");
}

// Adds entity observers to be able to listen to notifications
- (void)addTableReloadObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableViewReloadRequest)
                                                 name:NOTIFICATION_NAME__DEVICE_TABLE_REFRESH_REQUESTED
                                               object:nil];
    
}

- (void)tableViewReloadRequest {
    @try {
        [self reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

@end
