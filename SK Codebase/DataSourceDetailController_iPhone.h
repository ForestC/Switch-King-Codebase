//
//  DataSourceDetailController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKDataSource.h"

@interface DataSourceDetailController_iPhone : UITableViewController

@property (atomic, retain) SKDataSource *dataSource;

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityInfoLabel;
// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityValueLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityTimestampLabel;
// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNextUpdateLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityStatusLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UIImageView *entityIconImageView;

// Sets data for the view
- (void)setViewData;

@end
