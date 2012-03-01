//
//  SKEventBaseStdTableViewCell.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface SKEventBaseStdTableViewCell : UITableViewCell

// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityTimestampLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityActionLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNameLabel;
// Holds the entity icon
@property(nonatomic,weak) IBOutlet UIImageView *entityIconImageView;
// Holds the parent table view controller
@property(nonatomic,weak) UITableViewController *tableViewController;
// Holds the entity stored in the cell
@property(nonatomic,retain) SKEntity *entity;

@end
