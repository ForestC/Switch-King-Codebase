//
//  SKDeviceStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityActionRequest.h"

@interface SKDeviceStdTableViewCell : UITableViewCell {
    CGPoint gestureStartPoint;
	int verticalamount;
	int horizontalamount;
    CGPoint startLocation;
    EntityActionRequest *actionRequest;
    SKEntity* entity;
    Boolean swipeInProgress;
    Boolean swipeRequestsRestart;
}

@property(nonatomic,strong) IBOutlet UILabel *deviceName;
@property(nonatomic,strong) IBOutlet UILabel *deviceInfo;
@property(nonatomic,strong) IBOutlet UIView *actionView;
@property(nonatomic,strong) IBOutlet UILabel *actionInfo;
@property(nonatomic,strong) IBOutlet UIImageView *stateImage;
@property(nonatomic,strong) UITableViewController *tableViewController;
@property(nonatomic,retain) SKEntity *entity;

- (void)setSwipeLayerHidden:(Boolean)hidden;
- (void)initGestureRecognizers;
- (void)panGesture:(UIPanGestureRecognizer *)sender;
- (void)performRequestedAction;
- (Boolean)supportsAbsoluteDim;

@end
