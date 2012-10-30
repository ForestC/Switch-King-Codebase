//
//  GraphRequestGenerator.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface GraphRequestGenerator : NSObject

+ (NSString *)getGraphRequestPath:(SKEntity *) entity:(CGSize) graphSize:(NSInteger) minutesBack;

@end
