//
//  DeviceListViewController.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceListViewController.h"
#import "SKEntity.h"
#import "SKDevice.h"
#import "SKDeviceGroup.h"
#import "EntityActionRequest.h"
#import "EntityRequestGenerator.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ImagePathHelper.h"
#import "TextHelper.h"

@implementation DeviceListViewController

@synthesize groups;
@synthesize devices;
@synthesize groupsAndDevices;
//@synthesize deviceGroupCellStd;

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Called when entity data has been updated
- (void) entityDataUpdated:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__DEVICES_UPDATED]) {
        // Log
        NSLog (@"DeviceListViewController received info that devices are updated");
        
        // Get the dictionary
        NSDictionary * dict = [notification userInfo];
        
        // Pass the device data to the method
        [self handleUpdatedDevices:[dict valueForKey:@"Devices"]]; 
    } else if ([[notification name] isEqualToString:@"DeviceUpdated"]) {
        NSLog (@"DeviceListViewController received info that a device is updated");
    } else if ([[notification name] isEqualToString:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED]) {
        NSLog (@"DeviceListViewController received info that a dirtification has been updated");
        [[self tableView] reloadData];
    }  
}

- (void) handleUpdatedDevices:(NSMutableArray *) deviceData {
    // Create the internal structure
    [self createDeviceGroupStructure:deviceData];
    // Forces reload of data
    [self.tableView reloadData];
}

// Creates the internal device/group structure in order to provide easy access
// to these entities from the UITableViewController.
- (void) createDeviceGroupStructure:(NSMutableArray *) deviceData {
    NSMutableDictionary * tempGroupDictStore = [[NSMutableDictionary alloc] init];    
    devices = [[NSMutableArray alloc] initWithCapacity:deviceData.count];
    groups = [[NSMutableArray alloc] initWithCapacity:deviceData.count];
    
    for(int n = 0; n < [deviceData count]; n = n + 1)
    {
        SKDevice * device = (SKDevice *)[deviceData objectAtIndex:n];
        
        NSString * groupId = [NSString stringWithFormat:@"%d", device.GroupID];
        
        SKDeviceGroup * group = (SKDeviceGroup *)[tempGroupDictStore valueForKey:groupId];
        
        if(group == nil) {
            SKDeviceGroup * newGroup = [SKDeviceGroup alloc];
            
            newGroup.Name = device.GroupName;
            newGroup.ID = device.GroupID;
            newGroup.devices = [[NSMutableArray alloc] init];
            [newGroup.devices addObject:device];
            
            [tempGroupDictStore setValue:newGroup forKey:[groupId copy]];            
        } else {
            [group.devices addObject:device];
            
            NSLog(@"Adding to group %@, now with %i devices", group.Name, group.devices.count);
        }
        
        [devices addObject:device]; 
        
        // Do your thing with the object.
        NSLog(@"%@", [device Name]);
    }
    
    // Set all group entities.
    [groups setArray:[tempGroupDictStore allValues]];
    
    groupsAndDevices = [[NSMutableArray alloc] initWithCapacity:groups.count+devices.count];
    
    for(int n=0; n<groups.count;n=n+1) {
        SKDeviceGroup * group = (SKDeviceGroup *)[groups objectAtIndex:n];
        
        [groupsAndDevices addObject:group];
        [groupsAndDevices addObjectsFromArray:group.devices];
    }
    
    NSLog(@"%i devices, %i groups", devices.count, groups.count);
}

- (id)initWithCoder:(NSCoder*)aDecoder 
{
    if(self = [super initWithCoder:aDecoder]) {
        // Add entity observers
        [self addEntityObservers];
    }
    
    return self;
}

// Adds entity observers to be able to listen to notifications
- (void) addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICES_UPDATED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:@"DeviceUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED
                                               object:nil];
}

/*******************************************************************************
 TableView Layout
*******************************************************************************/

- (UITableViewCell *) dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity {
    UITableViewCell *cell;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EntityStore *entityStore = appDelegate.entityStore;
    
    if([cellEntity isKindOfClass:[SKDevice class]]) {
        if([entityStore deviceIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKDeviceStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKDeviceStdTableViewCell*)cell).tableViewController = self;
        ((SKDeviceStdTableViewCell*)cell).entity = cellEntity;
    } else if([cellEntity isKindOfClass:[SKDeviceGroup class]]) {
        if([entityStore deviceGroupIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD];
        }

        if (cell == nil) {
            cell = [[SKDeviceGroupStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKDeviceGroupStdTableViewCell*)cell).tableViewController = self;        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // In this view, all devices are always grouped...
    return groups.count + devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKEntity * entity = (SKEntity *)[groupsAndDevices objectAtIndex:indexPath.row];
    
    // Dequeue or create
    UITableViewCell *cell = [self dequeueOrCreateTableViewCell:tableView :entity];
    
    if(
       [entity isKindOfClass:[SKDevice class]] ||
       [entity isKindOfClass:[SKDeviceGroup class]])
    {
        cell.tag = indexPath.row;
    } else {
        cell.tag = -1;
    }
    
    [self setTableViewCellData:cell :entity];
    
    //cell.deviceGroupName.text = entity.Name;
    //NSLog(@"Returning cell");
    return cell;

    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
//    }
//    
////    SKAPA EN SKDeviceGroupCellStd som ärver UITableViewCell
//    
//    SKEntity * entity = (SKEntity * )[groupsAndDevices objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = entity.Name;
//    NSLog(@"Returning cell");
//    return cell;
}


// Sets the table view cell data depending on the type of cell and entity
- (void) setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity {
    if([cell isKindOfClass:[SKDeviceStdTableViewCell class]]) {
        SKDeviceStdTableViewCell * deviceCell = (SKDeviceStdTableViewCell *)cell;
        SKDevice *device = (SKDevice *)cellEntity;
        
        [deviceCell.entityNameLabel setText:device.Name];
        [deviceCell.entityInfoLabel setText:[TextHelper getDeviceInfoText:device]];
        deviceCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDevice: device:@"DeviceList_"]];
    } else if([cell isKindOfClass:[SKDeviceGroupStdTableViewCell class]]) {
        SKDeviceGroupStdTableViewCell * deviceGroupCell = (SKDeviceGroupStdTableViewCell *)cell;
        SKDeviceGroup *deviceGroup = (SKDeviceGroup *)cellEntity;

        [deviceGroupCell.entityNameLabel setText:deviceGroup.Name];
        deviceGroupCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDeviceGroup: deviceGroup:@"DeviceList_"]];
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
////	CGFloat height;
//    
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
//        return 44.0;
//    } else {
//        return 88.0;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.tag > 0) {
        SKEntity *entity = (SKEntity *)[groupsAndDevices objectAtIndex:cell.tag];
        
        if([entity isKindOfClass:[SKDevice class]]) {
            SKDevice *device = (SKDevice *)entity;
            
            EntityActionRequest *r = [EntityActionRequest createByDeviceAction:
                                                                       device :
                                                           ACTION_ID__TURN_ON :
                                                                           20 :
                                                                            3];
            
            
            // Get the app delegte
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            [appDelegate entityActionRequestFired:nil :r];
            
        } else if([entity isKindOfClass:[SKDeviceGroup class]]) {
            SKDeviceGroup *deviceGroup = (SKDeviceGroup *)entity;            
        } 
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
