//
//  SKSystemMode.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKSystemMode : SKEntity

//------------------------------------------------------------
// Misc properties
@property (nonatomic, copy) NSString *Abbreviation;
@property (nonatomic, copy) NSString *Active;
@property (nonatomic, copy) NSString *Enabled;

@end
