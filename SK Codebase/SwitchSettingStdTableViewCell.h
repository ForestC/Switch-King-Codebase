//
//  SwitchSettingStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextSettingStdTableViewCell.h"

@interface SwitchSettingStdTableViewCell : UITableViewCell

// Holds the header label
@property(nonatomic,strong) IBOutlet UILabel *settingHeaderLabel;
// Holds the header text field
@property(nonatomic,strong) IBOutlet UISwitch *settingSwitch;


@end
