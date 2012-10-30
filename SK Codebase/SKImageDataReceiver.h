//
//  SKImageDataReceiver.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>
#import "SKDataReceiver.h"
#import "DataReceivedDelegate.h"

@interface SKImageDataReceiver : SKDataReceiver <DataReceivedDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, assign) NSInteger entityId;

- (id)initWithEntityId:(NSInteger)targetedEntityId;

@end
