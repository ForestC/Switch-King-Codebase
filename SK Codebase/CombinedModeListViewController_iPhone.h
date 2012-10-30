//
//  CombinedModeListViewController_iPhone.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface CombinedModeListViewController_iPhone  : UITableViewController

@property (atomic, retain) NSMutableArray *scenarios;
@property (atomic, retain) NSMutableArray *systemModes;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *refreshBarButtonItem;

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers;

// Called when entity data has been updated
- (void)entityDataUpdated:(NSNotification *)notification;

- (void)handleUpdatedScenarios:(NSMutableArray *)scenariosData;

- (void)handleUpdatedSystemModes:(NSMutableArray *)systemModesData;

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity;

// Sets the table view cell data depending on the type of cell and entity
- (void) setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity;

- (NSInteger)getEntityTypeForSection:(NSInteger) section;

@end
