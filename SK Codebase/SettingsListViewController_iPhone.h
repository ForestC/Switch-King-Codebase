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
@property(nonatomic,strong) IBOutlet UILabel *serverAddressHeaderLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *refreshIntervalHeaderLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *refreshAfterCommandHeaderLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *maxUpcomingEventsHeaderLabel;

@property(nonatomic,strong) IBOutlet UILabel *showLearnButtonHeaderLabel;

@property(nonatomic,strong) IBOutlet UILabel *groupDevicesHeaderLabel;

@property(nonatomic,strong) IBOutlet UILabel *reloadOnTabSwitchHeaderLabel;

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *serverAddressDetailLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *refreshIntervalDetailLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *refreshAfterCommandDetailLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *maxUpcomingEventsDetailLabel;

@property(nonatomic,strong) IBOutlet UISwitch *showLearnButtonDetailSwitch;

@property(nonatomic,strong) IBOutlet UISwitch *groupDevicesDetailSwitch;

@property(nonatomic,strong) IBOutlet UISwitch *reloadOnTabSwitchDetailSwitch;

// Sets view data
- (void)setViewData;

//// Gets the expected tag by index path.
//- (NSInteger)getExpectedTag:(NSIndexPath *)indexPath;
//
//// Dequeues or creates a new cell
//- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView: (NSInteger)tag;
//
//// Sets the table view cell data depending on the type of cell and entity
//- (void)setTableViewCellData:(UITableView *)tableView: (UITableViewCell *)cell;

@end
