//
//  SKGroupableEntity.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKEntity.h"

@interface SKGroupableEntity : SKEntity

//------------------------------------------------------------
// Group properties
@property (nonatomic, assign) NSInteger GroupID;
@property (nonatomic, copy) NSString *GroupName;

@end
