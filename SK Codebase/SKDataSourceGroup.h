//
//  SKDataSourceGroup.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDataSourceGroup : SKEntity

@property (atomic, retain) NSMutableArray *dataSources;

@end
