//
//  SKDevice.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDevice : SKEntity {
    NSInteger GroupID;
    NSString * GroupName;
}

@property (atomic, assign) NSInteger GroupID;
@property (atomic, retain) NSString * GroupName;

@end
