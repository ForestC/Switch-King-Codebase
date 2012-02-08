//
//  DeviceDetailController_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceDetailController_iPhone.h"
#import "ImagePathHelper.h"
#import "TextHelper.h"
#import "SettingsMgr.h"
#import "AppDelegate.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "EntityActionRequest.h"
#import "Constants.h"

@implementation DeviceDetailController_iPhone

@synthesize synhronizeButton;
@synthesize cancelSemiAutoButton;
@synthesize learnButton;
@synthesize entityCurrentPowerConsumptionLabel;
@synthesize entity;
@synthesize entityInfoLabel;
@synthesize entityNameLabel;
@synthesize entityIconImageView;
@synthesize entityLastEventLabel;
@synthesize entityNextEventLabel;
@synthesize entityTotalPowerConsumptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)synchronizeButtonClick {
    [self handleButtonClick:ACTION_ID__SYNCHRONIZE];
}

- (IBAction)cancelSemiAutoButtonClick {    
    [self handleButtonClick:ACTION_ID__CANCEL_SEMI_AUTO];
}

- (IBAction)learnButtonClick {
    [self handleButtonClick:ACTION_ID__SEND_LEARN];    
}

// Handles action
- (void)handleButtonClick:(NSInteger)actionId {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    EntityActionRequest *actionRequest = [EntityActionRequest alloc];
    
    actionRequest.actionId = actionId;
    actionRequest.entity = entity;
    actionRequest.reqActionDelay = 0;
    
    [appDelegate entityActionRequestFired:nil :actionRequest];
    
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setViewData];
}

// Sets data for the view
- (void)setViewData {
    if([entity isKindOfClass:[SKDevice class]]) {
        SKDevice *device = (SKDevice *)entity;
        
        [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDevice: device:@"DeviceList_"]]];
        [self.entityInfoLabel setText:device.Description];
        
        self.learnButton.hidden = ![SettingsMgr showLearnButton];
    } else {
        SKDeviceGroup *group = (SKDeviceGroup *)entity;
        
        [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDeviceGroup: group:@"DeviceList_"]]];
        [self.entityInfoLabel setText:[TextHelper getDeviceGroupInfoText:group]];
        
        self.learnButton.hidden = true;
    }
    
    [self.entityNameLabel setText:entity.Name];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

@end
