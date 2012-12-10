//
//  DataSourceGraphController_iPhone.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import "DataSourceGraphController_iPhone.h"
#import "TextHelper.h"
#import "ImagePathHelper.h"
#import "Constants.h"
#import "EntityGraphRequest.h"
#import "CommunicationMgr.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@implementation DataSourceGraphController_iPhone
@synthesize dataSource;

@synthesize entityInfoLabel;
@synthesize entityNameLabel;
@synthesize entityValueLabel;
@synthesize entityGraphImageView;
@synthesize entityIconImageView;
@synthesize activityIndicatorView;
@synthesize entityGraphNotAvailableLabel;
@synthesize graphHistorySegment;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self addEntityObservers];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addEntityObservers];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        // Add entity observers
        [self addEntityObservers];
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
    [self configureRefreshButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeEntityObservers];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation duration:(NSTimeInterval)duration {
    [self setViewData];
}

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(graphDataUpdated:)
                                                 name:NOTIFICATION_NAME__GRAPH_DIRTIFICATION_UPDATING
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(graphDataUpdated:)
                                                 name:NOTIFICATION_NAME__GRAPH_UPDATED
                                               object:nil];
}

- (void)removeEntityObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:NOTIFICATION_NAME__GRAPH_DIRTIFICATION_UPDATING
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_NAME__GRAPH_UPDATED
                                                  object:nil];
}


// Called when entity data has been updated
- (void)graphDataUpdated:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__GRAPH_UPDATED]) {
        // Log
        NSLog (@"DataSourceGraphController received info that graph is updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        NSString *entityIdString = [dict valueForKey:GRAPH_UPDATE_NOTIFICATION__GRAPH_ENTITY_KEY];
        NSInteger entityId = [entityIdString integerValue];
        
        if(entityId == self.dataSource.ID) {
            // Pass the device data to the method
            [self handleUpdatedGraph:[dict valueForKey:GRAPH_UPDATE_NOTIFICATION__GRAPH_DATA_KEY]];
        }
    }
}

- (void)handleUpdatedGraph:(NSData *)graphData {
    entityGraphImageView.image = [[UIImage alloc] initWithData:graphData];
    
    [activityIndicatorView stopAnimating];
    
    if(entityGraphImageView.image.size.width == 0) {
        entityGraphNotAvailableLabel.hidden = false;
    } else {
        entityGraphNotAvailableLabel.hidden = true;
    }
}

- (void)configureRefreshButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(requestUpdateOfGraph)];
}

// Sets data for the view
- (void)setViewData {
    [self.entityIconImageView setImage:[UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DataSourceList_"]]];
    
    [self.entityNameLabel setText:dataSource.Name];
    [self.entityInfoLabel setText:dataSource.Description];
    
    [self.entityValueLabel setText:[TextHelper getDataSourceValueText:dataSource]];
    
    self.entityGraphImageView.image = NULL;
    
    entityGraphNotAvailableLabel.hidden = true;
    
    [self.activityIndicatorView startAnimating];
    
    [self requestUpdateOfGraph];
}

- (void)requestUpdateOfGraph {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.communicationMgr requestUpdateOfSystemModes];
    
    NSInteger segment = self.graphHistorySegment.selectedSegmentIndex;
    NSInteger minutesBack;
    
    switch (segment) {
        case 0:
            minutesBack = 60*4;
            break;
        case 1:
            minutesBack = 60*12;
            break;
        case 2:
            minutesBack = 60*24;
            break;
        case 3:
            minutesBack = 60*24*7;
            break;
        default:
            break;
    }
    
    CGSize size;
    
    size.width = self.entityGraphImageView.bounds.size.width;
    size.height = self.entityGraphImageView.bounds.size.height;
    
    EntityGraphRequest *req = [EntityGraphRequest createByDataSource:self.dataSource : size :minutesBack];
    
    // Request update of all entities...
    [appDelegate.communicationMgr requestEntityGraph:req];
}

- (IBAction)graphHistorySegmentTapped:(NSObject *)sender {
    [self requestUpdateOfGraph];
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
    return FALSE;
}

@end

