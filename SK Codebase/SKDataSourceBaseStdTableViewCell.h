//
//  SKDataSourceBaseStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDataSourceBaseStdTableViewCell : UITableViewCell

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityInfoLabel;
// Holds the entity icon
@property(nonatomic,strong) IBOutlet UIImageView *entityIconImageView;
// Holds the parent table view controller
@property(nonatomic,strong) UITableViewController *tableViewController;
// Holds the entity stored in the cell
@property(nonatomic,retain) SKEntity *entity;

@end
