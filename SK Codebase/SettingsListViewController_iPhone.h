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
@property(nonatomic,weak) IBOutlet UILabel *serverAddressHeaderLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *refreshIntervalHeaderLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *refreshAfterCommandHeaderLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *maxUpcomingEventsHeaderLabel;

@property(nonatomic,weak) IBOutlet UILabel *showLearnButtonHeaderLabel;

@property(nonatomic,weak) IBOutlet UILabel *groupDevicesHeaderLabel;

@property(nonatomic,weak) IBOutlet UILabel *reloadOnTabSwitchHeaderLabel;

// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *serverAddressDetailLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *refreshIntervalDetailLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *refreshAfterCommandDetailLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *maxUpcomingEventsDetailLabel;

@property(nonatomic,weak) IBOutlet UISwitch *showLearnButtonDetailSwitch;

@property(nonatomic,weak) IBOutlet UISwitch *groupDevicesDetailSwitch;

@property(nonatomic,weak) IBOutlet UISwitch *reloadOnTabSwitchDetailSwitch;

@property(nonatomic,weak) IBOutlet UILabel *versionLabel;

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
