//
//  SKScenarioTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKScenarioStdTableViewCell.h"

@implementation SKScenarioStdTableViewCell

// Holds the name of the entity
@synthesize entityNameLabel;
// Holds the info of the entity
@synthesize entityInfoLabel;
// Holds the entity icon
@synthesize entityIconImageView;
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
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/*******************************************************************************
 ??????
 *******************************************************************************/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
