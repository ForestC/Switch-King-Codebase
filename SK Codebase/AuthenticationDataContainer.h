//
//  AuthorizationContainer.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationDataContainer : NSObject

@property (atomic, retain) NSString * user;
@property (atomic, retain) NSString * pass;

@end
