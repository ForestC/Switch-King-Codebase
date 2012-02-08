//
//  DeviceListViewController.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKDeviceGroupStdTableViewCell.h"
#import "SKDeviceStdTableViewCell.h"
#import "SKEntity.h"

@interface DeviceListViewController : UITableViewController<UIGestureRecognizerDelegate> {
    //NSMutableArray * groupsAndDevices;
    //IBOutlet SKDeviceGroupStdTableViewCell * deviceGroupCellStd;
}

@property (atomic, retain) NSMutableArray *devices;
@property (atomic, retain) NSMutableArray *groups;
@property (atomic, retain) NSMutableArray *groupsAndDevices;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *refreshBarButtonItem;

//- (IBAction)handleLongPress:(id)sender;


//@property (nonatomic, strong) IBOutlet SKDeviceGroupStdTableViewCell * deviceGroupCellStd;
//@property (nonatomic, retain) SKDeviceGroupStdTableViewCell * deviceGroupCellStd;

// Adds entity observers to be able to listen to notifications
- (void) addEntityObservers;

// Called when entity data has been updated
- (void) entityDataUpdated:(NSNotification *) notification;

- (void) handleUpdatedDevices:(NSMutableArray *) deviceData;

- (void) createDeviceGroupStructure:(NSMutableArray *) deviceData;

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity;

// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity;

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;

// Gets children's index paths
//- (NSArray *)getIndexPathsForDeviceGroupChildren:(NSIndexPath *)path;

@end

@interface NSString (SortCompare)

-(NSInteger)stringCompare:(NSString *)str2;

@end

