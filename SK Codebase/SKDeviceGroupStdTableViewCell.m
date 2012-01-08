//
//  SKDeviceGroupStdTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDeviceGroupStdTableViewCell.h"

@implementation SKDeviceGroupStdTableViewCell

@synthesize deviceGroupName;
@synthesize deviceGroupInfo;
@synthesize stateImage;
@synthesize tableViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initGestureRecognizers];
    }
    return self;
}

- (void)initGestureRecognizers {
    UISwipeGestureRecognizer *swipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft)];
    UISwipeGestureRecognizer *swipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedRight)];
    
    swipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    
    swipeLEFT.numberOfTouchesRequired = 1;
    swipeRIGHT.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:swipeLEFT];
    [self addGestureRecognizer:swipeRIGHT];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWasSwipedLeft {
    NSLog(@"%@", "SWIPE LEFT");
}

- (void)cellWasSwipedRight {
    NSLog(@"%@", "SWIPE RIGHT");    
}


@end
