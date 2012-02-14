//
//  EventListViewController_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventListViewController_iPhone.h"
#include "Constants.h"
#import "AppDelegate.h"
#import "SKEntity.h"
#import "SKEvent.h"
#import "SKEventTableViewCell.h"
#import "TextHelper.h"
#import "ImagePathHelper.h"
#import "SettingsMgr.h"

@implementation EventListViewController_iPhone

@synthesize futureEvents;
@synthesize historicEvents;
@synthesize refreshBarButtonItem;
@synthesize eventDataSegmentedControl;

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

// Called when entity data has been updated
- (void)entityDataUpdated:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__EVENTS_UPDATED]) {
        // Log
        NSLog (@"EventListViewController received info that events are updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        // Log
        NSLog (@"EventListViewController received info that events are updated2");
        // Pass the dataSource data to the method
        [self handleUpdatedEvents:[dict valueForKey:@"Events"]]; 
        // Log
        NSLog (@"EventListViewController received info that events are updated33");
    } else if ([[notification name] isEqualToString:NOTIFICATION_NAME__EVENTS_DIRTIFICATION_UPDATED]) {
        NSLog (@"EventListViewController received info that a dirtification has been updated");
        [[self tableView] reloadData];
    }  
}

- (void)handleUpdatedEvents:(NSMutableArray *)eventData {
    [self interpretEvents:eventData];
    // Forces reload of data
    [self.tableView reloadData];
}

- (void)interpretEvents:(NSMutableArray *)eventData {
    NSMutableArray *newFuture =  [[NSMutableArray alloc] initWithCapacity:eventData.count];
    NSMutableArray *newHistoric =  [[NSMutableArray alloc] initWithCapacity:eventData.count];
    
    for(int i=0;i<eventData.count;i++) {
        SKEvent *evt = (SKEvent *)[eventData objectAtIndex:i];
        
        if ([TextHelper isFutureDate:evt.EventDate]) {
            [newFuture addObject:evt];
        } else {
            [newHistoric addObject:evt];
        }
    }
    
    self.historicEvents = newHistoric;
    self.futureEvents = newFuture;
}
             
             

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__EVENTS_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__EVENTS_DIRTIFICATION_UPDATED
                                               object:nil];
}

- (IBAction)eventDataSegmentedControlClick {
    [self.tableView reloadData];
}

/*******************************************************************************
 Misc
 *******************************************************************************/

- (void)refreshRequested {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.communicationMgr requestUpdateOfEvents];
}

/*******************************************************************************
 TableView Layout
 *******************************************************************************/

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity {
    UITableViewCell *cell;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EntityStore *entityStore = appDelegate.entityStore;
    
    if([cellEntity isKindOfClass:[SKEvent class]]) {
        if([entityStore eventIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__EVENT_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__EVENT_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKEventTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKEventTableViewCell *)cell).tableViewController = self;
        ((SKEventTableViewCell *)cell).entity = cellEntity;
    } else {
        static NSString *cellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
    }
    
    return cell;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Single section
    /*if(![SettingsMgr supportsHistoricEvents])
        return 1;
    
    if(historicEvents.count > 0 && futureEvents.count > 0)
        return 2;
    else        
        return 1;
     */ return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
    
    NSInteger type = [self getSectionContentType:section];
    
    switch (type) {
        case TABLE_VIEW_SECTION_TYPE__HISTORIC_EVENTS:
            return NSLocalizedStringFromTable(@"Historic", @"Texts", nil);
            break;
            
        default:
            return NSLocalizedStringFromTable(@"Future", @"Texts", nil);
            break;
    }
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger idx = [self.eventDataSegmentedControl selectedSegmentIndex];
    
    if(idx == 0) {
        return self.historicEvents.count + self.futureEvents.count;
    } else if(idx == 2) {
        return self.historicEvents.count;
    } else {
        return self.futureEvents.count;
    }
    /*
    
    if([self.eventDataSegmentedControl selectedSegmentIndex == 0
    
    NSInteger type = [self getSectionContentType:section];
    
    switch (type) {
        case TABLE_VIEW_SECTION_TYPE__HISTORIC_EVENTS:
            return historicEvents.count;
            break;
            
        default:
            return futureEvents.count;
            break;
    }*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKEntity *entity;
/*
    NSInteger type = [self getSectionContentType:indexPath.section];

    switch (type) {
        case TABLE_VIEW_SECTION_TYPE__HISTORIC_EVENTS:
            entity = (SKEntity *)[historicEvents objectAtIndex:indexPath.row];
            break;
            
        default:
            entity = (SKEntity *)[futureEvents objectAtIndex:indexPath.row];
            break;
    }*/
    
    NSInteger idx = [self.eventDataSegmentedControl selectedSegmentIndex];
    
    if(idx == 0) {
        if(indexPath.row > historicEvents.count - 1)
            entity = (SKEntity *)[futureEvents objectAtIndex:indexPath.row - historicEvents.count];
        else
            entity = (SKEntity *)[historicEvents objectAtIndex:indexPath.row];
    } else if(idx == 1) {
        entity = (SKEntity *)[futureEvents objectAtIndex:indexPath.row];
    } else {
        NSInteger idx = (historicEvents.count - indexPath.row - 1);
        entity = (SKEntity *)[historicEvents objectAtIndex:idx];
    }
    
    // Dequeue or create
    UITableViewCell *cell = [self dequeueOrCreateTableViewCell:tableView :entity];
    
    [self setTableViewCellData:cell :entity];
    
    return cell;
}


// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity {
    if([cell isKindOfClass:[SKEventTableViewCell class]]) {
        SKEventTableViewCell *eventCell = (SKEventTableViewCell *)cell;
        SKEvent *evt = (SKEvent *)cellEntity;
        NSString *entityType = evt.EntityType;
        
        if ([entityType isEqualToString:ENTITY_TYPE_STRING__SCENARIO]) {
            
        } else {
            [eventCell.entityNameLabel setText:evt.DeviceName];
            [eventCell.entityActionLabel setText:[TextHelper getEventInfoText:evt]];
            [eventCell.entityTimestampLabel setText:[TextHelper getFormattedDateText:evt.EventDate:false]];
            eventCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromEvent: evt:@"EventList_"]];
        }
        //dataSourceCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DeviceList_"]];
    }
    
    //FIXA HÄR
    
//    if([cell isKindOfClass:[SKDataSourceStdTableViewCell class]]) {
//        SKDataSourceStdTableViewCell *dataSourceCell = (SKDataSourceStdTableViewCell *)cell;
//        SKDataSource *dataSource = (SKDataSource *)cellEntity;
//        
//        [dataSourceCell.entityNameLabel setText:dataSource.Name];
//        [dataSourceCell.entityInfoLabel setText:[TextHelper getDataSourceValueText:dataSource]];
//        dataSourceCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DataSourceList_"]];
//    } else if([cell isKindOfClass:[SKDataSourceGroupStdTableViewCell class]]) {
//        SKDataSourceGroupStdTableViewCell *dataSourceGroupCell = (SKDataSourceGroupStdTableViewCell *)cell;
//        SKDataSourceGroup *dataSourceGroup = (SKDataSourceGroup *)cellEntity;
//        
//        if(dataSourceGroup.ID == -1) {
//            [dataSourceGroupCell.entityNameLabel setText:NSLocalizedStringFromTable(@"(none)", @"Texts", nil)];
//        } else {
//            [dataSourceGroupCell.entityNameLabel setText:dataSourceGroup.Name];
//        }
//        dataSourceGroupCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDataSourceGroup: dataSourceGroup:@"DataSourceList_"]];
//        [dataSourceGroupCell.entityInfoLabel setText:[TextHelper getDataSourceGroupInfoText:dataSourceGroup]];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    if(cell.tag > -1) {
//        SKEntity *entity = (SKEntity *)[dataSources objectAtIndex:cell.tag];
//        
//        if([entity isKindOfClass:[SKDataSource class]]) {
//            //            dataSourceDetailController_iPhone *detailController = [[dataSourceDetailController_iPhone alloc] initWithNibName:nil bundle:nil];
//            DataSourceDetailController_iPhone *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DataSourceDetails"];
//            
//            // Assign data source
//            [detailController setDataSource:(SKDataSource *)entity];
//            
//            [self.navigationController pushViewController:detailController animated:true];
//            
//            //            SKDataSource *dataSource = (SKDataSource *)entity;
//            //            
//            //            EntityActionRequest *r = [EntityActionRequest createBydataSourceAction:
//            //                                                                       dataSource :
//            //                                                           ACTION_ID__TURN_ON :
//            //                                                                           20 :
//            //                                                                            3];
//            //            
//            //            
//            //            // Get the app delegte
//            //            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            //
//            //            [appDelegate entityActionRequestFired:nil :r];
//            
//        } else if([entity isKindOfClass:[SKDataSourceGroup class]]) {
//            //SKDataSourceGroup *dataSourceGroup = (SKDataSourceGroup *)entity;            
//        } 
//    }
}

// Gets the content type for a specific section
- (NSInteger)getSectionContentType:(NSInteger)section {
    if(section == 1)
        return TABLE_VIEW_SECTION_TYPE__FUTURE_EVENTS;
    else if(section == 0) {
        if(historicEvents.count == 0)
            return TABLE_VIEW_SECTION_TYPE__FUTURE_EVENTS;
        else
            return TABLE_VIEW_SECTION_TYPE__HISTORIC_EVENTS;
    }
    
    return TABLE_VIEW_SECTION_TYPE__HISTORIC_EVENTS;
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![SettingsMgr supportsHistoricEvents] && self.eventDataSegmentedControl.subviews.count == 3) {
        [self.eventDataSegmentedControl removeSegmentAtIndex:2 animated:false];
    }
    
    [self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshBarButtonItem setTarget:self];
    [self.refreshBarButtonItem setAction:@selector(refreshRequested)];
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
    return YES;
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
