//
//  Base64Encoding.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encoding : NSObject

+ (NSString *)encodeBase64WithData:(NSData *)objData;

@end
