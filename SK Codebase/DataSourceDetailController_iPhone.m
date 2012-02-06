//
//  DataSourceDetailController_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSourceDetailController_iPhone.h"
#import "StateHelper.h"
#import "TextHelper.h"
#include "Constants.h"
#import "ImagePathHelper.h"

@implementation DataSourceDetailController_iPhone

@synthesize dataSource;

@synthesize entityInfoLabel;
@synthesize entityNameLabel;
@synthesize entityValueLabel;
@synthesize entityStatusLabel;
@synthesize entityIconImageView;
@synthesize entityTimestampLabel;
@synthesize entityNextUpdateLabel;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setViewData];
}

// Sets data for the view
- (void)setViewData {
    [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DataSourceList_"]]];
    
    [self.entityNameLabel setText:dataSource.Name];
    [self.entityInfoLabel setText:dataSource.Description];

    [self.entityValueLabel setText:[TextHelper getDataSourceValueText:dataSource]];
    [self.entityStatusLabel setText:[TextHelper getFormattedDataSourceStatusText:dataSource]];
    [self.entityTimestampLabel setText:[TextHelper getFormattedDateText:dataSource.UsedValueTimestamp:true]];
    
    if([DATA_SOURCE__POLL_SCHEDULE_TYPE__WHEN_MODIFIED isEqualToString:dataSource.PollScheduleType]) {
        [self.entityNextUpdateLabel setText:NSLocalizedStringFromTable(@"When data is modified", @"Texts", nil)];
    } else {
        if ([DATETIME__MAX_VALUE isEqualToString:dataSource.NextRun])
            [self.entityNextUpdateLabel setText:NSLocalizedStringFromTable(@"Unknown", @"Texts", nil)];
        else
            [self.entityNextUpdateLabel setText:[TextHelper getFormattedDateText:dataSource.NextRun:true]];
    }
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
    return YES;
}

@end
