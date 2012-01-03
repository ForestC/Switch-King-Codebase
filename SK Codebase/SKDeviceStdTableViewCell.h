//
//  SKDeviceStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKDeviceStdTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *deviceName;
@property(nonatomic,strong) IBOutlet UILabel *deviceInfo;
@property(nonatomic,strong) IBOutlet UIImageView *stateImage;

@end
