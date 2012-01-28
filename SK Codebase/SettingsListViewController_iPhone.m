//
//  SettingsListViewController.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsListViewController_iPhone.h"
#import "AppDelegate.h"
#import "SettingsMgr.h"

@implementation SettingsListViewController_iPhone

@synthesize serverAddressDetailLabel;
@synthesize serverAddressHeaderLabel;
@synthesize maxUpcomingEventsDetailLabel;
@synthesize maxUpcomingEventsHeaderLabel;
@synthesize refreshAfterCommandDetailLabel;
@synthesize refreshAfterCommandHeaderLabel;
@synthesize refreshIntervalHeaderLabel;
@synthesize refreshIntervalDetailLabel;
@synthesize reloadOnTabSwitchHeaderLabel;
@synthesize reloadOnTabSwitchDetailSwitch;
@synthesize groupDevicesHeaderLabel;
@synthesize groupDevicesDetailSwitch;
@synthesize showLearnButtonHeaderLabel;
@synthesize showLearnButtonDetailSwitch;

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

// Sets view data
- (void)setViewData {
    // Headers/Footers
    
    // Address
    [self.serverAddressDetailLabel setText:[SettingsMgr getTargetAddress:false]];
    [self.serverAddressHeaderLabel setText:NSLocalizedStringFromTable(@"Address", @"Texts", nil)];
    
    // Learn
    [self.showLearnButtonDetailSwitch setOn:[SettingsMgr showLearnButton]];
    [self.showLearnButtonHeaderLabel setText:NSLocalizedStringFromTable(@"Show Learn button", @"Texts", nil)];
    
    // Refresh interval
    NSInteger refreshInterval = [SettingsMgr getRefreshInterval];
    NSString *refreshIntervalStr = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%i sec", @"Texts", nil), refreshInterval];
    [self.refreshIntervalDetailLabel setText:refreshIntervalStr];
    [self.refreshIntervalHeaderLabel setText:NSLocalizedStringFromTable(@"Refresh interval", @"Texts", nil)];
    
    // Refresh after command
    NSInteger deviceUpdateInterval = [SettingsMgr getDeviceUpdateDelay];
    NSString *deviceUpdateStr = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%i sec", @"Texts", nil), deviceUpdateInterval];
    [self.refreshAfterCommandDetailLabel setText:deviceUpdateStr];
    [self.refreshAfterCommandHeaderLabel setText:NSLocalizedStringFromTable(@"Refresh after command", @"Texts", nil)];
    
    // Max upcoming events
    [self.maxUpcomingEventsDetailLabel setText:[NSString stringWithFormat:@"%i", [SettingsMgr getMaxUpcomingEvents]]];
    [self.maxUpcomingEventsHeaderLabel setText:NSLocalizedStringFromTable(@"Max upcoming events", @"Texts", nil)];
    
    // Group devices
    [self.groupDevicesDetailSwitch setOn:[SettingsMgr groupDevices]];
    [self.groupDevicesHeaderLabel setText:NSLocalizedStringFromTable(@"Group devices", @"Texts", nil)];
    
    // Refresh on tab switch
    [self.reloadOnTabSwitchDetailSwitch setOn:[SettingsMgr enableReloadOnTabSwitch]];
    [self.reloadOnTabSwitchHeaderLabel setText:NSLocalizedStringFromTable(@"Refresh on tab switch", @"Texts", nil)];
}

- (void)switchTouched:(UIControl *)sender
{
    UISwitch *s = (UISwitch*)sender;
    
    if(s == self.reloadOnTabSwitchDetailSwitch) {
        [SettingsMgr setEnableReloadOnTabSwitch:s.on];
    } else if(s == self.groupDevicesDetailSwitch) {
        [SettingsMgr setGroupDevices:s.on];        
    } else if(s == self.showLearnButtonDetailSwitch) {
        [SettingsMgr setShowLearnButton:s.on];
    }
    [SettingsMgr setUseLive:s.on];
    
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.reloadOnTabSwitchDetailSwitch addTarget:self 
                                           action:@selector(switchTouched:)
                                 forControlEvents:UIControlEventValueChanged];
    
    [self.groupDevicesDetailSwitch addTarget:self 
                                           action:@selector(switchTouched:)
                                 forControlEvents:UIControlEventValueChanged];

    [self.showLearnButtonDetailSwitch addTarget:self 
                                           action:@selector(switchTouched:)
                                 forControlEvents:UIControlEventValueChanged];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate toggleAlertInfo:false];
    
    [self setViewData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self setViewData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
