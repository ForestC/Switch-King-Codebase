//
//  SKDataReceiver.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"

@interface SKDataReceiver : NSObject

@property (nonatomic, weak) EntityStore *entityStore;

@end
