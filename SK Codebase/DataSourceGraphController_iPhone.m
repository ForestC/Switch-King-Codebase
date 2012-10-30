//
//  DataSourceGraphController_iPhone.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import "DataSourceGraphController_iPhone.h"
#import "TextHelper.h"

@implementation DataSourceGraphController_iPhone
@synthesize dataSource;

@synthesize entityInfoLabel;
@synthesize entityNameLabel;
@synthesize entityValueLabel;
@synthesize entityGraphImageView;

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
   // [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DataSourceList_"]]];
    
    [self.entityNameLabel setText:dataSource.Name];
    [self.entityInfoLabel setText:dataSource.Description];
    
    [self.entityValueLabel setText:[TextHelper getDataSourceValueText:dataSource]];
}

#pragma mark - View lifecycle

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

