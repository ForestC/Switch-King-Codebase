//
//  SKSystemSetting.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKSystemSetting : SKEntity {
    NSString *DataType;
    NSString *Value;
}

@property (atomic, retain) NSString *DataType;
@property (atomic, retain) NSString *Value;

@end