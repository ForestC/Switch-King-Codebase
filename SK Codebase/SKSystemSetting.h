//
//  SKSystemSetting.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKSystemSetting : SKEntity

//------------------------------------------------------------
// Misc properties
@property (nonatomic, copy) NSString *DataType;
@property (nonatomic, copy) NSString *Value;

@end