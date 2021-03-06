//
//  SKDeviceBaseStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityActionRequest.h"

@interface SKDeviceBaseStdTableViewCell : UITableViewCell {
    CGPoint gestureStartPoint;
	int verticalAmount;
	int horizontalAmount;
    CGPoint startLocation;
    NSInteger actionRequestAction;
    NSInteger actionRequestDimLevel;
    Boolean swipeInProgress;
    Boolean swipeRequestsRestart;
    Boolean swipeLayerVisible;
    Boolean currentlyInCancelArea;
    Boolean swipeEnabled;
}

// Is swipe enabled or not
@property(nonatomic,assign) Boolean swipeEnabled;
// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityInfoLabel;
// Holds the entity icon
@property(nonatomic,weak) IBOutlet UIImageView *entityIconImageView;
// Holds a button for detecting toggling of state
@property(nonatomic,weak) IBOutlet UIButton *entityStateToggleButton;
// Holds the parent table view controller
@property(nonatomic,strong) UITableViewController *tableViewController;
// Holds the entity stored in the cell
@property(nonatomic,retain) SKEntity *entity;

// Hides or shows the swipe info layer
- (void)setSwipeLayerHidden:(Boolean)hidden;
// Initializes gesture recognizers
- (void)initGestureRecognizers;
// Called when a pan gesture is detected
- (void)panGesture:(UIPanGestureRecognizer *)sender;
// Performs the requested action
- (void)performRequestedAction;
// Indicates whether the entity supports absolute dim
- (Boolean)supportsAbsoluteDim;


- (IBAction)toggleButtonClick;

@end
