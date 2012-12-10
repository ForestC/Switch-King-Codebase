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
#import "DeviceDetailController_iPhone.h"
#import "SettingsMgr.h"

@implementation DeviceListViewController

@synthesize groups;
@synthesize devices;
@synthesize groupsAndDevices;
@synthesize refreshBarButtonItem;
@synthesize isScrolling;
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
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                              initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 0.5; //seconds
        lpgr.delegate = self;
        [self.tableView addGestureRecognizer:lpgr];
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
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__DEVICES_UPDATED]) {
        // Log
        NSLog (@"DeviceListViewController received info that devices are updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        // Pass the device data to the method
        [self handleUpdatedDevices:[dict valueForKey:@"Devices"]]; 
    } else if ([[notification name] isEqualToString:NOTIFICATION_NAME__DEVICE_UPDATED]) {
        NSLog (@"DeviceListViewController received info that a device is updated");
    } else if (
               [[notification name] isEqualToString:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED] ||
               [[notification name] isEqualToString:NOTIFICATION_NAME__DEVICE_GROUP_DIRTIFICATION_UPDATED]) {
        NSLog (@"DeviceListViewController received info that a dirtification has been updated");
        [self requestTableViewReload];
    }  
}

- (void)handleUpdatedDevices:(NSMutableArray *) deviceData {
    // Create the internal structure
    [self createDeviceGroupStructure:deviceData];
    // Forces reload of data
    [self requestTableViewReload];
}

// Creates the internal device/group structure in order to provide easy access
// to these entities from the UITableViewController.
- (void)createDeviceGroupStructure:(NSMutableArray *) deviceData {
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
        }
        
        [devices addObject:device]; 
        
        // Do your thing with the object.
        //NSLog(@"%@", [device Name]);
    }
    
    if([SettingsMgr groupDevices]) {    
        // Set all group entities.
        NSArray *tempGroups = [NSArray arrayWithArray:[tempGroupDictStore allValues]];
        
        NSString *noneGroup;
        
        groupsAndDevices = [[NSMutableArray alloc] initWithCapacity:tempGroups.count+devices.count];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<tempGroups.count; i++) {
            NSString *name = ((SKDeviceGroup *)[tempGroups objectAtIndex:i]).Name;
            
            if(name == nil) {
                noneGroup = @"ÖÖÖÖÖÖ";
            } else {
                [arr addObject:(NSString*)name];
            }
        }
        
        [arr sortUsingSelector:@selector(stringCompare:)];
        
        if(noneGroup != nil && [noneGroup isEqualToString:@"ÖÖÖÖÖÖ"]) {
            [arr addObject:noneGroup];
        }
        
        for(int i=0;i<arr.count;i++) {
            for(int j=0;j<tempGroups.count;j++) {
                SKDeviceGroup *g = (SKDeviceGroup *)[tempGroups objectAtIndex:j];
                
                if([((NSString *)[arr objectAtIndex:i]) isEqualToString:@"ÖÖÖÖÖÖ"]) {
                    if(g.Name == nil) {
                        [groups addObject:g];
                    }
                } else if(g.Name != nil && [g.Name isEqualToString:((NSString *)[arr objectAtIndex:i])])
                    [groups addObject:g];            
            }
        }
        
        
        for(int n=0; n<groups.count;n=n+1) {
            SKDeviceGroup * group = (SKDeviceGroup *)[groups objectAtIndex:n];
            
            [groupsAndDevices addObject:group];
            
            if([SettingsMgr deviceGroupIsExpanded:group.ID])
                [groupsAndDevices addObjectsFromArray:group.devices];
        }
    } else {
        groupsAndDevices = [[NSMutableArray alloc] initWithArray:devices];
    }
    
    NSLog(@"%i devices, %i groups after update", devices.count, groups.count);
}

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICES_UPDATED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICE_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__DEVICE_GROUP_DIRTIFICATION_UPDATED
                                               object:nil];

}

/*******************************************************************************
 Misc
 *******************************************************************************/

- (void)refreshRequested {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate.communicationMgr requestUpdateOfDevices];
}

- (void)requestTableViewReload {
/*    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:NOTIFICATION_NAME__DEVICE_TABLE_REFRESH_REQUESTED
                                      object:nil
                                    userInfo:nil];*/
    [self.tableView reloadData];
}   

/*******************************************************************************
 TableView Layout
*******************************************************************************/

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity {
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
        
        SKDeviceStdTableViewCell *typedCell =         ((SKDeviceStdTableViewCell *)cell);
        
        typedCell.tableViewController = self;
        typedCell.entity = cellEntity;

        // Reset Swipe data
        [typedCell setSwipeLayerHidden:true];
        // Enable/disable swipe
        [typedCell setSwipeEnabled:[SettingsMgr deviceListSwipeEnabled]];
        
        if([SettingsMgr deviceListToggleEnabled]) {
            [typedCell.entityStateToggleButton setEnabled:true]; 
        } else {
            [typedCell.entityStateToggleButton setEnabled:false]; 
        }

    } else if([cellEntity isKindOfClass:[SKDeviceGroup class]]) {
        if([entityStore deviceGroupIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD];
        }

        if (cell == nil) {
            cell = [[SKDeviceGroupStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKDeviceGroupStdTableViewCell *)cell).tableViewController = self;
        ((SKDeviceGroupStdTableViewCell *)cell).entity = cellEntity;
        
        // Reset Swipe data
        [((SKDeviceGroupStdTableViewCell *)cell) setSwipeLayerHidden:true];
        // Enable/disable swipe
        [((SKDeviceGroupStdTableViewCell *)cell) setSwipeEnabled:[SettingsMgr deviceListSwipeEnabled]];
        
        if([SettingsMgr deviceListToggleEnabled]) {
            [((SKDeviceGroupStdTableViewCell *)cell).entityStateToggleButton setEnabled:true]; 
        } else {
            [((SKDeviceGroupStdTableViewCell *)cell).entityStateToggleButton setEnabled:false]; 
        }
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(self.groupsAndDevices.count == 0)
        return nil;    
    
    if([SettingsMgr groupDevices]) {
        return NSLocalizedStringFromTable(@"Swipe to send command\nHold group to expand or collapse", @"Texts", nil);
    } else {
        return NSLocalizedStringFromTable(@"Swipe to send command", @"Texts", nil);        
    }
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // In this view, all devices are always grouped...
    return groupsAndDevices.count;// groups.count + devices.count;
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
- (void)setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity {
    if([cell isKindOfClass:[SKDeviceStdTableViewCell class]]) {
        SKDeviceStdTableViewCell *deviceCell = (SKDeviceStdTableViewCell *)cell;
        SKDevice *device = (SKDevice *)cellEntity;
        
        [deviceCell.entityNameLabel setText:device.Name];
        [deviceCell.entityInfoLabel setText:[TextHelper getDeviceInfoText:device]];
        deviceCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDevice: device:@"DeviceList_"]];
    } else if([cell isKindOfClass:[SKDeviceGroupStdTableViewCell class]]) {
        SKDeviceGroupStdTableViewCell *deviceGroupCell = (SKDeviceGroupStdTableViewCell *)cell;
        SKDeviceGroup *deviceGroup = (SKDeviceGroup *)cellEntity;

        if(deviceGroup.ID == -1) {
            [deviceGroupCell.entityNameLabel setText:NSLocalizedStringFromTable(@"(none)", @"Texts", nil)];
        } else {
            [deviceGroupCell.entityNameLabel setText:deviceGroup.Name];
        }
        deviceGroupCell.entityIconImageView.image = [UIImage imageNamed:[ImagePathHelper getImageNameFromDeviceGroup: deviceGroup:@"DeviceList_"]];
        [deviceGroupCell.entityInfoLabel setText:[TextHelper getDeviceGroupInfoText:deviceGroup]];
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
    [self requestTableViewReload];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.tag > -1) {
        SKEntity *entity = (SKEntity *)[groupsAndDevices objectAtIndex:cell.tag];
        
        if(
           [entity isKindOfClass:[SKDevice class]] ||
           [entity isKindOfClass:[SKDeviceGroup class]]) {
            Boolean supportsDim;
            
            if([entity isKindOfClass:[SKDevice class]]) {
                supportsDim = [XML_VALUE__TRUE isEqualToString:((SKDevice *)entity).SupportsAbsoluteDimLvl];
            } else {
                supportsDim = ((SKDeviceGroup *)entity).supportsAbsoluteDim;
            }
            
            // Create controller
            DeviceDetailController_iPhone *detailController;
            
            if(!supportsDim)
                detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"RelayDeviceDetails"];
            else
                detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DimmableDeviceDetails"];
            
            // Assign entity
            detailController.entity = entity;
            // Navigate
            [self.navigationController pushViewController:detailController animated:true];
        } 
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%@", @"SCROLL");
    [self setIsScrolling:true];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setIsScrolling:false];    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];

    if(indexPath != nil && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:false];
        
        
        NSLog(@"long press on table view at row %d", indexPath.row);
        
        SKEntity *entity = [groupsAndDevices objectAtIndex:indexPath.row];
        
        if([entity isKindOfClass:[SKDeviceGroup class]]) {
            [SettingsMgr toggleDeviceGroupExpanded:entity.ID];
                        
            [self createDeviceGroupStructure:devices];
        }
        
        [self requestTableViewReload];
    }
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshBarButtonItem setTarget:self];
    [self.refreshBarButtonItem setAction:@selector(refreshRequested)];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.75; //seconds
    lpgr.delegate = self;
    
    [self.tableView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestTableViewReload];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

@implementation NSString (SortCompare)

-(NSInteger) stringCompare:(NSString *)str2
{
    if([@"ÖÖÖÖÖÖ" isEqualToString:self])
        return NSIntegerMax;
    return [(NSString *)self localizedCaseInsensitiveCompare:str2];
}

@end

