//
//  SKEntity.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKEntity : NSObject
{
    NSInteger ID;
    NSString * Name;
}

@property (atomic, assign) NSInteger ID;
@property (atomic, retain) NSString * Name;

@end
