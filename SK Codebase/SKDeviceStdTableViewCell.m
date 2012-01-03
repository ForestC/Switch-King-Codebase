//
//  SKDeviceStdTableViewCell.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDeviceStdTableViewCell.h"

@implementation SKDeviceStdTableViewCell

@synthesize deviceName;
@synthesize deviceInfo;
@synthesize stateImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    
//    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
//    CGContextSetStrokeColor(c, red);
//    CGContextBeginPath(c);
//    CGContextMoveToPoint(c, 0.0f, 0.0f);
//    CGContextAddLineToPoint(c, 150.0f, 150.0f);
//    CGContextStrokePath(c);
//}


@end
