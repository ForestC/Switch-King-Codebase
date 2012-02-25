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
@synthesize onButton;
@synthesize offButton;
@synthesize dimLevelLabel;
@synthesize dimLevelSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    [self initDimLevelTexts];
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

- (IBAction)onButtonClick {
    [self handleButtonClick:ACTION_ID__TURN_ON];    
}

- (IBAction)offButtonClick {
    [self handleButtonClick:ACTION_ID__TURN_OFF];    
}

- (IBAction)dimSliderDrag {
    [self handleSliderChange];    
}

- (IBAction)dimSliderValueChanged {
    [self handleSliderChange];    
}

- (IBAction)dimSliderTouchUpInside {
    float sliderValue = self.dimLevelSlider.value;
    
    NSInteger dimLevel = 10 * ((int)(sliderValue + 0.5));
    
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    EntityActionRequest *actionRequest = [EntityActionRequest alloc];
    
    if(dimLevel==0)
        actionRequest.actionId = ACTION_ID__TURN_OFF;
    else
        actionRequest.actionId = ACTION_ID__TURN_ON;
    actionRequest.dimLevel = dimLevel;
    actionRequest.entity = entity;
    actionRequest.reqActionDelay = 0;
    
    [appDelegate entityActionRequestFired:nil :actionRequest];
    
    [self.navigationController popToRootViewControllerAnimated:true];
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

// Handles slider action
- (void)handleSliderChange {
    float sliderValue = self.dimLevelSlider.value;
    
    NSInteger dimLevel = 10 * ((int)(sliderValue + 0.5));
    
    if (dimLevel == 0)
        [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:0]];
    else
        [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:(dimLevel / 10)]];
}

// Initializes dim level texts to display in slider
- (void)initDimLevelTexts {
    NSString *dimFormatString = NSLocalizedStringFromTable(@"Dim %i%%", @"Texts", nil);
    NSString *on = NSLocalizedStringFromTable(@"On", @"Texts", nil);
    NSString *off = NSLocalizedStringFromTable(@"Off", @"Texts", nil);
    
    dimLevelTexts = [NSArray arrayWithObjects:
                     off,
                     [NSString stringWithFormat:dimFormatString, 10],
                     [NSString stringWithFormat:dimFormatString, 20],
                     [NSString stringWithFormat:dimFormatString, 30],
                     [NSString stringWithFormat:dimFormatString, 40],
                     [NSString stringWithFormat:dimFormatString, 50],
                     [NSString stringWithFormat:dimFormatString, 60],
                     [NSString stringWithFormat:dimFormatString, 70],
                     [NSString stringWithFormat:dimFormatString, 80],
                     [NSString stringWithFormat:dimFormatString, 90],
                     on,                     
                     nil];
}

/*
if (entity is RESTDevice) {
    var device = (RESTDevice)entity;
    this.nameLabel.Text = System.Web.HttpUtility.HtmlDecode (device.Name);
    this.descLabel.Text = TextHelper.GetInfoText (device);
    this.stateImage.Image = UIImage.FromFile (GetImagePath (device));
    
    if (device.CurrentStateID == Application.DEVICE_STATE_ID__ON) {
        if (device.CurrentDimLevel > 0 && device.CurrentDimLevel < 100)
            dimSlider.Value = device.CurrentDimLevel / 10;
        else
            dimSlider.Value = dimSlider.MaxValue;
    } else {
        dimSlider.Value = dimSlider.MinValue;
    }
    
    SetDimValue (dimSlider.Value);
} else if (entity is RESTDeviceGroup) {
    var deviceGroup = (RESTDeviceGroup)entity;
    var name = String.IsNullOrEmpty (deviceGroup.Name) ? Localization.GetLocalizedTextString ("(none)") : System.Web.HttpUtility.HtmlDecode (deviceGroup.Name);
    var devices = String.Format (Localization.GetLocalizedTextString ("{0} devices"), deviceGroup.Devices.Count.ToString());
    this.nameLabel.Text = name;
    this.descLabel.Text = devices;
    this.stateImage.Image = UIImage.FromFile (GetImagePath (deviceGroup));
    SetDimValue (dimSlider.Value);
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setViewData];
}

// Sets data for the view
- (void)setViewData {
    Boolean isDimDeviceView = self.dimLevelSlider != nil;    
    
    if([entity isKindOfClass:[SKDevice class]]) {
        SKDevice *device = (SKDevice *)entity;
        
        [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDevice: device:@"DeviceList_"]]];
        [self.entityInfoLabel setText:device.Description];
        
        self.learnButton.hidden = ![SettingsMgr showLearnButton];
        
        if(isDimDeviceView) {
            [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:0]];
            
            if (device.CurrentStateID == DEVICE_STATE_ID__ON) {
                if (device.CurrentDimLevel > 0 && device.CurrentDimLevel < 100)
                    [self.dimLevelSlider setValue:(device.CurrentDimLevel / 10)];
                else
                    [self.dimLevelSlider setValue:self.dimLevelSlider.maximumValue];
            } else {
                [self.dimLevelSlider setValue:self.dimLevelSlider.minimumValue];
            }
            
            NSInteger dimLevel = device.CurrentDimLevel;
            
            if (dimLevel == 0)
                [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:0]];
            else if(device.CurrentStateID == DEVICE_STATE_ID__ON && dimLevel == -1)
                [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:10]];
            else
                [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:(dimLevel / 10)]];

        }
    } else {
        SKDeviceGroup *group = (SKDeviceGroup *)entity;
        
        [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDeviceGroup: group:@"DeviceList_"]]];
        [self.entityInfoLabel setText:[TextHelper getDeviceGroupInfoText:group]];
        
        self.learnButton.hidden = true;
        
        if(isDimDeviceView) {
            [self.dimLevelLabel setText:[dimLevelTexts objectAtIndex:0]];
            [self.dimLevelSlider setValue:self.dimLevelSlider.minimumValue];
        }

    }
    
    [self.entityNameLabel setText:entity.Name];
    [self setTitle:entity.Name];
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
