//
//  DataReceiverDelegate.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EntityDataReceiverDelegate <NSObject>

@required
-(void) entityDataReceived:(NSObject *) src : (NSObject *) obj;

@end
