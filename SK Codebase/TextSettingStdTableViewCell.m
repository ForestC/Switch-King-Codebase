//
//  TextSettingStdTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextSettingStdTableViewCell.h"

@implementation TextSettingStdTableViewCell

@synthesize settingHeaderLabel;
@synthesize settingTextField;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //[self initGestureRecognizers];
        //actionRequest = [[EntityActionRequest alloc] init];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self initGestureRecognizers];
    }
    return self;
}

@end
