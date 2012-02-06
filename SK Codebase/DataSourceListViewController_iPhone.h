//
//  DataSourceListViewController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface DataSourceListViewController_iPhone : UITableViewController

@property (atomic, retain) NSMutableArray *dataSources;
@property (atomic, retain) NSMutableArray *groups;
@property (atomic, retain) NSMutableArray *groupsAndDataSources;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *refreshBarButtonItem;

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers;

// Called when entity data has been updated
- (void)entityDataUpdated:(NSNotification *)notification;

- (void)handleUpdatedDataSources:(NSMutableArray *)dataSourceData;

- (void)createDataSourceGroupStructure:(NSMutableArray *)dataSourceData;

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity;

// Sets the table view cell data depending on the type of cell and entity
- (void) setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity;

// Indicates whether entities in this view are to be grouped
- (BOOL)entitiesGrouped;

@end
