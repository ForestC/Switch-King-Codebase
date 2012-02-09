//
//  SKScenario.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKScenario : SKEntity {
    NSString *Abbreviation;
    NSString *Active;
    NSString *Enabled;
}

@property (atomic, retain) NSString *Abbreviation;
@property (atomic, retain) NSString *Active;
@property (atomic, retain) NSString *Enabled;

@end
