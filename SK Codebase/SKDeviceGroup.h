//
//  SKDeviceGroup.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDeviceGroup : SKEntity

@property (atomic, retain) NSMutableArray * devices;

@end
