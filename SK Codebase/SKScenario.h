//
//  SKScenario.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKScenario : SKEntity

//------------------------------------------------------------
// Misc properties
@property (nonatomic, copy) NSString *Abbreviation;
@property (nonatomic, copy) NSString *Active;
@property (nonatomic, copy) NSString *Enabled;

@end
