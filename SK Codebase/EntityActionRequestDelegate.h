//
//  EntityActionRequestDelegate.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityActionRequest.h"

@protocol EntityActionRequestDelegate <NSObject>

@required
- (void)entityActionRequestFired:(NSObject *) src : (EntityActionRequest *) req;

@end
