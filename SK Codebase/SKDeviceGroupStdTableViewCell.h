//
//  SKDeviceGroupStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKDeviceGroupStdTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *deviceGroupName;
@property(nonatomic,strong) IBOutlet UILabel *deviceGroupInfo;
@property(nonatomic,strong) IBOutlet UIImageView *stateImage;

@end
