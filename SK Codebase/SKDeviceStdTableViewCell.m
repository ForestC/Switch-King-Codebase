//
//  SKDeviceStdTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDeviceStdTableViewCell.h"
#include "Constants.h"
#import "AppDelegate.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "SKEntity.h"

@implementation SKDeviceStdTableViewCell

@synthesize deviceName;
@synthesize deviceInfo;
@synthesize stateImage;
@synthesize actionInfo;
@synthesize actionView;
@synthesize tableViewController;
@synthesize entity;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initGestureRecognizers];
        actionRequest = [[EntityActionRequest alloc] init];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initGestureRecognizers {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];

    [self addGestureRecognizer:pan];
    [pan setDelegate:self];
}


- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        gestureStartPoint = [sender locationInView:self];
        swipeRequestsRestart = false;
        swipeInProgress = true;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if(swipeInProgress) {
            swipeRequestsRestart = true;
            [self setSwipeLayerHidden :true];
            [self performRequestedAction];
        }
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        if(swipeRequestsRestart)
            return;
        
        CGPoint currentPosition = [sender locationInView:self];
        verticalamount = currentPosition.y - gestureStartPoint.y;
        horizontalamount = currentPosition.x - gestureStartPoint.x;
        CGRect r = [self bounds];
        
        if(currentPosition.y < -SWIPE_MARGIN__Y_MOVEMENT || currentPosition.y > r.size.height + SWIPE_MARGIN__Y_MOVEMENT) {
            [self setSwipeLayerHidden :true];
            gestureStartPoint = [sender locationInView:self];
            swipeInProgress = false;
            swipeRequestsRestart = true;
            return;
        }
               
        if(![self supportsAbsoluteDim]) {
            
            if (currentPosition.x - SWIPE_MARGIN__DETECTION_THRESHOLD > gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                
                [actionInfo setText:NSLocalizedStringFromTable(@"On", @"Texts", nil)];
                [actionRequest setDimLevel:100];
                [actionRequest setActionId:ACTION_ID__TURN_ON];
            }
            else if (currentPosition.x + SWIPE_MARGIN__DETECTION_THRESHOLD < gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                
                [actionInfo setText:NSLocalizedStringFromTable(@"Off", @"Texts", nil)];
                [actionRequest setDimLevel:0];
                [actionRequest setActionId:ACTION_ID__TURN_OFF];
            }
            
            return;
        }
        
        
        if (verticalamount < 0) {
            verticalamount = verticalamount/-1;
        }
        if (horizontalamount < 0) {
            horizontalamount = horizontalamount/-1;
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
        
        if (horizontalamount > verticalamount) {
            if (currentPosition.x - SWIPE_MARGIN__DETECTION_THRESHOLD > gestureStartPoint.x || currentPosition.x + SWIPE_MARGIN__DETECTION_THRESHOLD < gestureStartPoint.x) {
                [self setSwipeLayerHidden :false];
                       
                if(i == 0) {
                    [actionInfo setText:NSLocalizedStringFromTable(@"Off", @"Texts", nil)];
                    [actionRequest setDimLevel:0];
                    [actionRequest setActionId:ACTION_ID__TURN_OFF];
                } else if (i == 100) {
                    [actionInfo setText:NSLocalizedStringFromTable(@"On", @"Texts", nil)];
                    [actionRequest setDimLevel:100];
                    [actionRequest setActionId:ACTION_ID__TURN_ON];
                } else {                    
                    NSString *str = NSLocalizedStringFromTable(@"Dim %i%%", @"Texts", nil);
                    str = [NSString stringWithFormat:str, i];
                    [actionInfo setText:str];
                    [actionRequest setDimLevel:i];
                    [actionRequest setActionId:ACTION_ID__TURN_ON];
                }
            }
        }
    }
}

- (void)performRequestedAction {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DeviceListViewController* vc = (DeviceListViewController*)self.tableViewController;
    
    if(self.tag > 0) {
        SKEntity *cellEntity = (SKEntity *)[vc.groupsAndDevices objectAtIndex:self.tag];
        
        if([entity isKindOfClass:[SKDevice class]]) {
            SKDevice *device = (SKDevice *)cellEntity;
            
            actionRequest.entity = device;
            actionRequest.reqActionDelay = 0;
            
            [appDelegate entityActionRequestFired:nil :actionRequest];
        } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
            SKDeviceGroup *deviceGroup = (SKDeviceGroup *)cellEntity;            
        } 
    }
}

- (void)setSwipeLayerHidden:(Boolean)hidden {
    CGFloat alpha;
    
    [actionInfo setHidden:hidden];
    
    
    if(hidden) {
        alpha = 1.0f;
    } else {
        alpha = 0.5f;        
    }
    
    [stateImage setAlpha:alpha];
    [deviceName setAlpha:alpha];
    [deviceInfo setAlpha:alpha];
}

- (Boolean)supportsAbsoluteDim {
    if([entity isKindOfClass:[SKDevice class]]) {
        SKDevice *device = (SKDevice *)entity;
        
        return [[device SupportsAbsoluteDimLvl] isEqualToString:XML_VALUE__TRUE];
    } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
        return YES;            
    } 
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

@end
