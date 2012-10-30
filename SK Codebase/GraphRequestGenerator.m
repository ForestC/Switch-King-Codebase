//
//  GraphRequestGenerator.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import "GraphRequestGenerator.h"
#import "SKDataSource.h"

@implementation GraphRequestGenerator

+ (NSString *)getGraphRequestPath:(SKEntity *) entity:(CGSize) graphSize:(NSInteger) minutesBack {
    NSString *url;
    
    if([entity isKindOfClass:[SKDataSource class]]) {
        url = [NSString stringWithFormat:@"/datasources/%d/graph.png?width=%d&height=%d&minutesofhistory=%d", entity.ID, (int)graphSize.width, (int)graphSize.height, minutesBack];
    } else {
        NSLog(@"Invalid type for graph request.");
    }
    
    return url;
}

@end
