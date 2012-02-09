//
//  ScenarioListViewController.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface ScenarioListViewController_iPhone : UITableViewController

@property (atomic, retain) NSMutableArray *scenarios;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *refreshBarButtonItem;

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers;

// Called when entity data has been updated
- (void)entityDataUpdated:(NSNotification *)notification;

- (void)handleUpdatedScenarios:(NSMutableArray *)scenariosData;

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity;

// Sets the table view cell data depending on the type of cell and entity
- (void) setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity;

@end
