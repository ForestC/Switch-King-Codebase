//
//  ServerSettingsListViewController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerSettingsListViewController_iPhone : UITableViewController<UITextFieldDelegate>

// Gets the expected tag by index path.
- (NSInteger)getExpectedTag:(NSIndexPath *)indexPath;

// Dequeues or creates a new cell
- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView: (NSInteger)tag;

// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableView *)tableView: (UITableViewCell *)cell;

@end
