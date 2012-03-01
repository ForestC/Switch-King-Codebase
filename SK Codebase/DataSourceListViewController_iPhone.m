//
//  DataSourceListViewController_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSourceListViewController_iPhone.h"
#include "Constants.h"
#import "SKDataSource.h"
#import "SKDataSourceGroup.h"
#import "AppDelegate.h"
#import "SKDataSourceStdTableViewCell.h"
#import "SKDataSourceGroupStdTableViewCell.h"
#import "TextHelper.h"
#import "ImagePathHelper.h"
#import "DataSourceDetailController_iPhone.h"
#import "SettingsMgr.h"

@implementation DataSourceListViewController_iPhone

@synthesize groups;
@synthesize dataSources;
@synthesize groupsAndDataSources;
@synthesize refreshBarButtonItem;
//@synthesize dataSourceGroupCellStd;

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
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__DATA_SOURCES_UPDATED]) {
        // Log
        NSLog (@"DataSourceListViewController received info that data source are updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        // Pass the dataSource data to the method
        [self handleUpdatedDataSources:[dict valueForKey:@"DataSources"]]; 
    } else if ([[notification name] isEqualToString:NOTIFICATION_NAME__DATA_SOURCE_UPDATED]) {
        NSLog (@"DataSourceListViewController received info that a data source is updated");
    } else if (
               [[notification name] isEqualToString:NOTIFICATION_NAME__DATA_SOURCE_DIRTIFICATION_UPDATED] ||
               [[notification name] isEqualToString:NOTIFICATION_NAME__DATA_SOURCE_GROUP_DIRTIFICATION_UPDATED]) {
        NSLog (@"DataSourceListViewController received info that a dirtification has been updated");
        [[self tableView] reloadData];
    }  
}

- (void)handleUpdatedDataSources:(NSMutableArray *)dataSourceData {
    // Create the internal structure
    [self createDataSourceGroupStructure:dataSourceData];
    // Forces reload of data
    [self.tableView reloadData];
}

// Creates the internal dataSource/group structure in order to provide easy access
// to these entities from the UITableViewController.
- (void)createDataSourceGroupStructure:(NSMutableArray *) dataSourceData {
    NSMutableDictionary * tempGroupDictStore = [[NSMutableDictionary alloc] init];    
    dataSources = [[NSMutableArray alloc] initWithCapacity:dataSourceData.count];
    groups = [[NSMutableArray alloc] initWithCapacity:dataSourceData.count];
    
    for(int n = 0; n < [dataSourceData count]; n = n + 1)
    {
        SKDataSource *dataSource = (SKDataSource *)[dataSourceData objectAtIndex:n];
        
        NSString * groupId = [NSString stringWithFormat:@"%d", dataSource.GroupID];
        
        SKDataSourceGroup *group = (SKDataSourceGroup *)[tempGroupDictStore valueForKey:groupId];
        
        if(group == nil) {
            SKDataSourceGroup *newGroup = [SKDataSourceGroup alloc];
            
            newGroup.Name = dataSource.GroupName;
            newGroup.ID = dataSource.GroupID;
            newGroup.dataSources = [[NSMutableArray alloc] init];
            [newGroup.dataSources addObject:dataSource];
            
            [tempGroupDictStore setValue:newGroup forKey:[groupId copy]];            
        } else {
            [group.dataSources addObject:dataSource];
            
            //NSLog(@"Adding to group %@, now with %i dataSources", group.Name, group.dataSources.count);
        }
        
        [dataSources addObject:dataSource]; 
        
        // Do your thing with the object.
        //NSLog(@"%@", [dataSource Name]);
    }
    
    // Set all group entities.
    [groups setArray:[tempGroupDictStore allValues]];
    
    groupsAndDataSources = [[NSMutableArray alloc] initWithCapacity:groups.count+dataSources.count];
    
    for(int n=0; n<groups.count;n=n+1) {
        SKDataSourceGroup *group = (SKDataSourceGroup *)[groups objectAtIndex:n];
        
        [groupsAndDataSources addObject:group];
        [groupsAndDataSources addObjectsFromArray:group.dataSources];
    }
    
    NSLog(@"%i data sources, %i groups after update", dataSources.count, groups.count);
}


// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DATA_SOURCES_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DATA_SOURCE_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DATA_SOURCE_DIRTIFICATION_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DATA_SOURCE_GROUP_DIRTIFICATION_UPDATED
                                               object:nil];    
}

/*******************************************************************************
 Misc
 *******************************************************************************/

- (void)refreshRequested {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.communicationMgr requestUpdateOfDataSources];
    
    //    NSLog(<#NSString *format, ...#>)
}

/*******************************************************************************
 TableView Layout
 *******************************************************************************/

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity {
    UITableViewCell *cell;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EntityStore *entityStore = appDelegate.entityStore;
    
    if([cellEntity isKindOfClass:[SKDataSource class]]) {
        if([entityStore dataSourceIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DATA_SOURCE_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DATA_SOURCE_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKDataSourceStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKDataSourceStdTableViewCell *)cell).tableViewController = self;
        ((SKDataSourceStdTableViewCell *)cell).entity = cellEntity;
    } else if([cellEntity isKindOfClass:[SKDataSourceGroup class]]) {
        if([entityStore dataSourceGroupIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DATA_SOURCE_GROUP_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DATA_SOURCE_GROUP_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKDataSourceGroupStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKDataSourceGroupStdTableViewCell *)cell).tableViewController = self;
        ((SKDataSourceGroupStdTableViewCell *)cell).entity = cellEntity;
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
    //return 1;
    if([self entitiesGrouped])
        return groups.count;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([self entitiesGrouped]) {
        SKDataSourceGroup *group = (SKDataSourceGroup *)[groups objectAtIndex:section];
        
        if(group.ID == GROUP_ID__NONE)
            return NSLocalizedStringFromTable(@"(none)", @"Texts", nil);
        else
            return group.Name;
    } else {
        return nil;
    }
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
/*    if([self entitiesGrouped])
        return groups.count + dataSources.count;
    else
        return dataSources.count;*/
    if([self entitiesGrouped])
        return ((SKDataSourceGroup *)[groups objectAtIndex:section]).dataSources.count;
    else
        return dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKEntity *entity;
    
//    if([self entitiesGrouped])
//        entity = (SKEntity *)[groupsAndDataSources objectAtIndex:indexPath.row];
//    else
//        entity = (SKEntity *)[dataSources objectAtIndex:indexPath.row];
    
    entity = (SKEntity *)[dataSources objectAtIndex:indexPath.row];
    
    // Dequeue or create
    UITableViewCell *cell = [self dequeueOrCreateTableViewCell:tableView :entity];
    
    if(
       [entity isKindOfClass:[SKDataSource class]] ||
       [entity isKindOfClass:[SKDataSourceGroup class]])
    {
        cell.tag = indexPath.row;
    } else {
        cell.tag = -1;
    }
    
    [self setTableViewCellData:cell :entity];
    
    return cell;
}


// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity {
    if([cell isKindOfClass:[SKDataSourceStdTableViewCell class]]) {
        SKDataSourceStdTableViewCell *dataSourceCell = (SKDataSourceStdTableViewCell *)cell;
        SKDataSource *dataSource = (SKDataSource *)cellEntity;
        
        [dataSourceCell.entityNameLabel setText:dataSource.Name];
        [dataSourceCell.entityInfoLabel setText:[TextHelper getDataSourceValueText:dataSource]];
        dataSourceCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDataSource: dataSource:@"DataSourceList_"]];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [dataSourceCell.entityTimestampLabel setText:[TextHelper getFormattedDateText:dataSource.UsedValueTimestamp:true]];
        }
    } else if([cell isKindOfClass:[SKDataSourceGroupStdTableViewCell class]]) {
        SKDataSourceGroupStdTableViewCell *dataSourceGroupCell = (SKDataSourceGroupStdTableViewCell *)cell;
        SKDataSourceGroup *dataSourceGroup = (SKDataSourceGroup *)cellEntity;
        
        if(dataSourceGroup.ID == -1) {
            [dataSourceGroupCell.entityNameLabel setText:NSLocalizedStringFromTable(@"(none)", @"Texts", nil)];
        } else {
            [dataSourceGroupCell.entityNameLabel setText:dataSourceGroup.Name];
        }
        dataSourceGroupCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDataSourceGroup: dataSourceGroup:@"DataSourceList_"]];
        [dataSourceGroupCell.entityInfoLabel setText:[TextHelper getDataSourceGroupInfoText:dataSourceGroup]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.tag > -1) {
        SKEntity *entity = (SKEntity *)[dataSources objectAtIndex:cell.tag];
        
        if([entity isKindOfClass:[SKDataSource class]]) {
            //            dataSourceDetailController_iPhone *detailController = [[dataSourceDetailController_iPhone alloc] initWithNibName:nil bundle:nil];
            DataSourceDetailController_iPhone *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DataSourceDetails"];
            
            // Assign data source
            [detailController setDataSource:(SKDataSource *)entity];
            
            [self.navigationController pushViewController:detailController animated:true];
            
            //            SKDataSource *dataSource = (SKDataSource *)entity;
            //            
            //            EntityActionRequest *r = [EntityActionRequest createBydataSourceAction:
            //                                                                       dataSource :
            //                                                           ACTION_ID__TURN_ON :
            //                                                                           20 :
            //                                                                            3];
            //            
            //            
            //            // Get the app delegte
            //            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //
            //            [appDelegate entityActionRequestFired:nil :r];
            
        } else if([entity isKindOfClass:[SKDataSourceGroup class]]) {
            //SKDataSourceGroup *dataSourceGroup = (SKDataSourceGroup *)entity;            
        } 
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%@", @"SCROLL");
}

// Indicates whether entities in this view are to be grouped
- (BOOL)entitiesGrouped {
    // In this view, all dataSources are always grouped...
    if([SettingsMgr groupDataSources]) {
        if(groups.count == 0 || (groups.count == 1 && ((SKDataSourceGroup *)[groups objectAtIndex:0]).ID == GROUP_ID__NONE))
            return FALSE;
        return TRUE;
    } else {
        return FALSE;
    }
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
