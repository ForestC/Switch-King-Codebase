//
//  Base64Enc.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Enc : NSObject

+ (NSString *) base64StringFromData: (NSData *)data length: (int)length;

@end
