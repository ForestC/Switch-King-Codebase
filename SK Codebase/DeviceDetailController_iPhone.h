//
//  DeviceDetailController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface DeviceDetailController_iPhone : UITableViewController

@property (atomic, retain) SKEntity *entity;

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityInfoLabel;
// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityLastEventLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNextEventLabel;
// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityTotalPowerConsumptionLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityCurrentPowerConsumptionLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UIImageView *entityIconImageView;


@property (atomic, retain) IBOutlet UIButton *synhronizeButton;
@property (atomic, retain) IBOutlet UIButton *learnButton;
@property (atomic, retain) IBOutlet UIButton *cancelSemiAutoButton;

- (IBAction)synchronizeButtonClick;
- (IBAction)cancelSemiAutoButtonClick;
- (IBAction)learnButtonClick;

// Sets data for the view
- (void)setViewData;

// Handles action
- (void)handleButtonClick:(NSInteger)actionId;

@end
