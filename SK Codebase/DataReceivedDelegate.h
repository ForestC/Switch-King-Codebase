//
//  DataReceivedDelegate.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SK_Codebase_DataReceivedDelegate_h
#define SK_Codebase_DataReceivedDelegate_h

#import <Foundation/Foundation.h>
#import "EntityStore.h"

@protocol DataReceivedDelegate <NSObject>

@required
- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData;
- (id)initWithEntityStore:(EntityStore *)store;

@end

#endif
