//
//  SKDeviceBaseStdTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "Constants.h"
#import "AppDelegate.h"
#import "SKDeviceBaseStdTableViewCell.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"

@implementation SKDeviceBaseStdTableViewCell

// Holds the name of the entity
@synthesize entityNameLabel;
// Holds the info of the entity
@synthesize entityInfoLabel;
// Holds the entity icon
@synthesize entityIconImageView;
// Holds the action label used to show what's happening
@synthesize actionLabel;
// Holds the parent table view controller
@synthesize tableViewController;
// Holds the entity stored in the cell
@synthesize entity;

/*******************************************************************************
 Init methods
 *******************************************************************************/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initGestureRecognizers];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initGestureRecognizers];
    }
    return self;
}

// Initializes gesture recognizers
- (void)initGestureRecognizers {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    
    [self addGestureRecognizer:pan];
    [pan setDelegate:self];
}

/*******************************************************************************
 ??????
 *******************************************************************************/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*******************************************************************************
 Gesture recognitions
 *******************************************************************************/

// Handles when the table is scrolled while the view is swiped
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

// Handles when the table is scrolled while the view is swiped
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// Handles when the table is scrolled while the view is swiped
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

// Called when a pan gesture is detected
- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        gestureStartPoint = [sender locationInView:self];
        swipeRequestsRestart = false;
        swipeInProgress = true;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if(swipeInProgress && swipeLayerVisible) {
            swipeRequestsRestart = true;
            [self setSwipeLayerHidden :true];
            [self performRequestedAction];
        }
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        if(swipeRequestsRestart)
            return;
        
        CGPoint currentPosition = [sender locationInView:self];
        verticalAmount = currentPosition.y - gestureStartPoint.y;
        horizontalAmount = currentPosition.x - gestureStartPoint.x;
        CGRect r = [self bounds];
        
        if(
           currentPosition.y < -SWIPE_MARGIN__Y_MOVEMENT || 
           currentPosition.y > r.size.height + SWIPE_MARGIN__Y_MOVEMENT) {
            [self setSwipeLayerHidden :true];
            gestureStartPoint = [sender locationInView:self];
            swipeInProgress = false;
            swipeRequestsRestart = true;
            return;
        }
        
        if(![self supportsAbsoluteDim]) {
            
            if (currentPosition.x - SWIPE_MARGIN__DETECTION_THRESHOLD > gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                
                [actionLabel setText:NSLocalizedStringFromTable(@"On", @"Texts", nil)];
                
                actionRequestDimLevel = 100;
                actionRequestAction = ACTION_ID__TURN_ON;
            }
            else if (currentPosition.x + SWIPE_MARGIN__DETECTION_THRESHOLD < gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                
                [actionLabel setText:NSLocalizedStringFromTable(@"Off", @"Texts", nil)];
                
                actionRequestDimLevel = 0;
                actionRequestAction = ACTION_ID__TURN_OFF;
            }
            
            return;
        }
        
        if (verticalAmount < 0) {
            verticalAmount = verticalAmount/-1;
        }
        if (horizontalAmount < 0) {
            horizontalAmount = horizontalAmount/-1;
        }
        
        CGFloat leftBoundary = SWIPE_MARGIN__PER_SIDE;
        CGFloat rightBoundary = r.size.width - SWIPE_MARGIN__PER_SIDE;            
        CGFloat xPos = currentPosition.x;
        CGFloat span = r.size.width - (SWIPE_MARGIN__PER_SIDE * 2);
        
        if(xPos < leftBoundary)
            xPos = leftBoundary;
        if(xPos > rightBoundary)
            xPos = rightBoundary;
        
        CGFloat f = ((xPos - SWIPE_MARGIN__PER_SIDE)/span) * 10;
        NSInteger i = (f);
        i = i * 10;
        
        if (horizontalAmount > verticalAmount) {
            if (currentPosition.x - SWIPE_MARGIN__DETECTION_THRESHOLD > gestureStartPoint.x || currentPosition.x + SWIPE_MARGIN__DETECTION_THRESHOLD < gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                
                if(i == 0) {
                    [actionLabel setText:NSLocalizedStringFromTable(@"Off", @"Texts", nil)];
                    
                    actionRequestDimLevel = 0;
                    actionRequestAction = ACTION_ID__TURN_OFF;
                } else if (i == 100) {
                    [actionLabel setText:NSLocalizedStringFromTable(@"On", @"Texts", nil)];
                    
                    actionRequestDimLevel = 100;
                    actionRequestAction = ACTION_ID__TURN_ON;
                } else {                    
                    NSString *str = NSLocalizedStringFromTable(@"Dim %i%%", @"Texts", nil);
                    str = [NSString stringWithFormat:str, i];
                    [actionLabel setText:str];
                    
                    actionRequestDimLevel = i;
                    actionRequestAction = ACTION_ID__TURN_ON;
                }
            }
        }
    }
}

// Hides or shows the swipe info layer
- (void)setSwipeLayerHidden:(Boolean)hidden {
    CGFloat alpha;
    swipeLayerVisible = !hidden;
    [actionLabel setHidden:hidden];
    
    if(
       [self.reuseIdentifier isEqualToString:REUSE_IDENTIFIER__DEVICE_CELL_STD_DIRTY] ||
       [self.reuseIdentifier isEqualToString:REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD_DIRTY])
        return;
       
    if(hidden) {
        alpha = 1.0f;
    } else {
        alpha = 0.5f;        
    }
    
    [entityIconImageView setAlpha:alpha];
    [entityInfoLabel setAlpha:alpha];
    [entityNameLabel setAlpha:alpha];
}

/*******************************************************************************
 Actions
 *******************************************************************************/

// Performs the requested action
- (void)performRequestedAction {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DeviceListViewController* vc = (DeviceListViewController*)self.tableViewController;
    
    if(self.tag != -1) {
        SKEntity *cellEntity = (SKEntity *)[vc.groupsAndDevices objectAtIndex:self.tag];
        
        if([entity isKindOfClass:[SKDevice class]] ||
           [entity isKindOfClass:[SKDeviceGroup class]]) {
            //SKDevice *device = (SKDevice *)cellEntity;
            
            EntityActionRequest *actionRequest = [EntityActionRequest alloc];

            actionRequest.dimLevel = actionRequestDimLevel;
            actionRequest.actionId = actionRequestAction;
            actionRequest.entity = cellEntity;
            actionRequest.reqActionDelay = 0;
            
            [appDelegate entityActionRequestFired:nil :actionRequest];
        } 
    }
}


- (Boolean)supportsAbsoluteDim {
    if([entity isKindOfClass:[SKDevice class]]) {
        SKDevice *device = (SKDevice *)entity;
        
        return [[device SupportsAbsoluteDimLvl] isEqualToString:XML_VALUE__TRUE];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        SKDeviceGroup *group = (SKDeviceGroup *)entity;
        
        NSInteger supportsDim = 0;
        
        for (NSUInteger i = 0; i < group.devices.count; ++i) {
            if([((SKDevice *)[group.devices objectAtIndex:i]).SupportsAbsoluteDimLvl  isEqualToString:XML_VALUE__TRUE]) {
                supportsDim++;
                break;
            }
        }
        
        if(supportsDim > 0)
            return true;
        else
            return false;
    } 
    
    return NO;
}

@end
