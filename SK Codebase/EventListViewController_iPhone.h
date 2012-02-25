//
//  EventListViewController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface EventListViewController_iPhone : UITableViewController

@property (nonatomic, retain) NSMutableArray *futureEvents;
@property (nonatomic, retain) NSMutableArray *historicEvents;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, weak) IBOutlet UISegmentedControl *eventDataSegmentedControl;

- (IBAction)eventDataSegmentedControlClick;

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers;

// Called when entity data has been updated
- (void)entityDataUpdated:(NSNotification *)notification;

- (void)handleUpdatedEvents:(NSMutableArray *)eventData;

- (void)interpretEvents:(NSMutableArray *)eventData;

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity;

// Sets the table view cell data depending on the type of cell and entity
- (void) setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity;

// Gets the content type for a specific section
- (NSInteger)getDisplayedContentType;

@end
