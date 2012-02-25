//
//  DeviceDetailController_iPhone.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEntity.h"

@interface DeviceDetailController_iPhone : UITableViewController {
    // Holds text for dim levels
    NSArray *dimLevelTexts;
}

@property (atomic, retain) SKEntity *entity;

// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityInfoLabel;
// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityLastEventLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNextEventLabel;
// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityTotalPowerConsumptionLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityCurrentPowerConsumptionLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UIImageView *entityIconImageView;


@property (nonatomic, weak) IBOutlet UIButton *synhronizeButton;
@property (nonatomic, weak) IBOutlet UIButton *learnButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelSemiAutoButton;
@property (nonatomic, weak) IBOutlet UIButton *onButton;
@property (nonatomic, weak) IBOutlet UIButton *offButton;
@property (nonatomic, weak) IBOutlet UILabel *dimLevelLabel;
@property (nonatomic, weak) IBOutlet UISlider *dimLevelSlider;


- (IBAction)synchronizeButtonClick;
- (IBAction)cancelSemiAutoButtonClick;
- (IBAction)learnButtonClick;
- (IBAction)onButtonClick;
- (IBAction)offButtonClick;
- (IBAction)dimSliderValueChanged;
- (IBAction)dimSliderTouchUpInside;
- (IBAction)dimSliderDrag;

// Sets data for the view
- (void)setViewData;

// Handles action
- (void)handleButtonClick:(NSInteger)actionId;

// Handles slider action
- (void)handleSliderChange;

// Initializes dim level texts to display in slider
- (void)initDimLevelTexts;

@end
