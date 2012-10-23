//
//  SKModeBaseStdTableViewCell.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKModeBaseStdTableViewCell : UITableViewCell

// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityInfoLabel;
// Holds the entity icon
@property(nonatomic,weak) IBOutlet UIImageView *entityIconImageView;
// Holds the parent table view controller
@property(nonatomic,weak) UITableViewController *tableViewController;
// Holds the entity stored in the cell
@property(nonatomic,retain) SKEntity *entity;

@end