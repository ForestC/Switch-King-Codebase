//
//  SKEntity.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKEntity : NSObject

//------------------------------------------------------------
// Identification properties
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Description;

@end
