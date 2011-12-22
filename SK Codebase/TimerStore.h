//
//  TimerStore.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKEntity.h"

// Stores information about update timers
@interface TimerStore : NSObject

-(Boolean) hasRunningTimer:(SKEntity *)entity;

-(Boolean) invalidateTimer:(SKEntity *)entity;

-(void) createTimer:(SKEntity *)entity;

-(void) createTimer:(SKEntity *)entity;

@end
