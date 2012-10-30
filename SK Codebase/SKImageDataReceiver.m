//
//  SKImageDataReceiver.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import "SKImageDataReceiver.h"
#import <UIKit/UIImage.h>
#import <Foundation/Foundation.h>
#import "Constants.h"

@implementation SKImageDataReceiver

@synthesize imageView;
@synthesize entityId;

- (SKImageDataReceiver *)initWithEntityId:(NSInteger)targetedEntityId {
    self = [super init];
    
    // Set the store
    self.entityId = targetedEntityId;
    
    return self;
}

- (SKImageDataReceiver *)initWithEntityStore:(EntityStore *)store {
    self = [super init];
    
    // Set the store
    [super setEntityStore:store];
    
    return self;
}

- (void)dataReceived:(NSObject *) src : (NSMutableData *) receivedData {
    NSLog(@"SKImageMode data received");

    UIImage *image = [UIImage imageWithData:receivedData];
    
    NSLog(@"%fx%f for image data received", image.size.width, image.size.height);
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // Set the notification data
    NSDictionary *notificationData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      receivedData, GRAPH_UPDATE_NOTIFICATION__GRAPH_DATA_KEY,
                                      [NSString stringWithFormat:@"%d",entityId], GRAPH_UPDATE_NOTIFICATION__GRAPH_ENTITY_KEY, nil];
    
    
    [notificationCenter postNotificationName:NOTIFICATION_NAME__GRAPH_UPDATED
                                      object:nil
                                    userInfo:notificationData];
    
   // [imageView setImage:image];
}

@end