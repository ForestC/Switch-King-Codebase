//
//  SettingsListViewController.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsListViewController_iPhone : UITableViewController

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *serverAddressLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *updateIntervalLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *updateAfterActionLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *maxUpcomingEventsLabel;

@property(nonatomic,strong) IBOutlet UILabel *enableLearnLabel;

@end
