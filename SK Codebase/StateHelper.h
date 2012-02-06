//
//  StateHelper.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDataSource.h"

@interface StateHelper : NSObject

+ (NSInteger)getPresentedStatus:(SKDataSource*)ds;
+ (NSInteger)getDataSourceStatusFromString:(NSString*)status;
+ (NSInteger)getDataSourceValueStatusFromString:(NSString*)status;
+ (NSInteger)getPresentedDataSourceStatusFromDataSourceValueStatus:(NSInteger)dsvStatus;

@end
