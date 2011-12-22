//
//  EntityStoreDelegate.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SK_Codebase_EntityStoreDelegate_h
#define SK_Codebase_EntityStoreDelegate_h

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@protocol EntityStoreDelegate <NSObject>

@required
- (void)entityUpdated:(NSObject *) src : (SKEntity *) entity;
- (void)entityCollectionUpdated:(NSObject *) src : (NSMutableArray *) coll:(Class) entityClass;

@end

#endif
