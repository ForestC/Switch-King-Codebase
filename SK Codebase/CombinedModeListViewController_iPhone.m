//
//  CombinedModeListViewController_iPhone.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CombinedModeListViewController_iPhone.h"
#import "SKEntity.h"
#import "SKScenario.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "SKScenarioStdTableViewCell.h"
#import "SKSystemModeStdTableViewCell.h"

@implementation CombinedModeListViewController_iPhone
@synthesize scenarios;
@synthesize systemModes;
@synthesize refreshBarButtonItem;

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
    if ([[notification name] isEqualToString:NOTIFICATION_NAME__SCENARIOS_UPDATED]) {
        // Log
        NSLog (@"CombinedModeListViewController received info that scenarios are updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        // Pass the entity data to the method
        [self handleUpdatedScenarios:[dict valueForKey:@"Scenarios"]]; 
    } else if (
               [[notification name] isEqualToString:NOTIFICATION_NAME__SCENARIOS_DIRTIFICATION_UPDATED]) {
        NSLog (@"CombinedModeListViewController received info that a dirtification has been updated");
        [[self tableView] reloadData];
    } else if ([[notification name] isEqualToString:NOTIFICATION_NAME__SYSTEM_MODES_UPDATED]) {
        // Log
        NSLog (@"CombinedModeListViewController received info that system modes are updated");
        
        // Get the dictionary
        NSDictionary *dict = [notification userInfo];
        
        // Pass the entity data to the method
        [self handleUpdatedSystemModes:[dict valueForKey:@"SystemModes"]];
    } else if (
               [[notification name] isEqualToString:NOTIFICATION_NAME__SYSTEM_MODES_DIRTIFICATION_UPDATED]) {
        NSLog (@"CombinedModeListViewController received info that a dirtification has been updated");
        [[self tableView] reloadData];
    }
}

- (void)handleUpdatedScenarios:(NSMutableArray *)scenarioData {
    self.scenarios = [NSMutableArray arrayWithArray:scenarioData];
    
    // Forces reload of data
    [self.tableView reloadData];
}

- (void)handleUpdatedSystemModes:(NSMutableArray *)systemModeData {
    self.systemModes = [NSMutableArray arrayWithArray:systemModeData];
    
    // Forces reload of data
    [self.tableView reloadData];
}

// Adds entity observers to be able to listen to notifications
- (void)addEntityObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__SCENARIOS_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__SCENARIOS_DIRTIFICATION_UPDATED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__SYSTEM_MODES_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entityDataUpdated:)
                                                 name:NOTIFICATION_NAME__SYSTEM_MODES_DIRTIFICATION_UPDATED
                                               object:nil];
}

/*******************************************************************************
 Misc
 *******************************************************************************/

- (void)refreshRequested {
    // Get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate.communicationMgr requestUpdateOfSystemModes];
    [appDelegate.communicationMgr requestUpdateOfScenarios];
}

// Handles action
- (void)performAction:(SKEntity *)targetedEntity {
    // Get the app delegte
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    EntityActionRequest *actionRequest = [EntityActionRequest alloc];
    
    actionRequest.reqActionDelay = 0;
    
    if([targetedEntity isKindOfClass:[SKScenario class]]) {
        actionRequest.actionId = ACTION_ID__CHANGE_SCENARIO;
        actionRequest.entity = targetedEntity;
    } else {
        actionRequest.actionId = ACTION_ID__CHANGE_SYSTEM_MODE;
        actionRequest.entity = targetedEntity;
    }
    
    [appDelegate entityActionRequestFired:nil :actionRequest];
}


/*******************************************************************************
 TableView Layout
 *******************************************************************************/

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView :(SKEntity *)cellEntity {
    UITableViewCell *cell;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    EntityStore *entityStore = appDelegate.entityStore;
    
    if([cellEntity isKindOfClass:[SKScenario class]]) {
        if([entityStore scenarioIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__SCENARIO_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__SCENARIO_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKScenarioStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKScenarioStdTableViewCell *)cell).tableViewController = self;
        ((SKScenarioStdTableViewCell *)cell).entity = cellEntity;
    } else if([cellEntity isKindOfClass:[SKSystemMode class]]) {
        if([entityStore systemModeIsDirty:cellEntity.ID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__SYSTEM_MODE_CELL_STD_DIRTY];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER__SYSTEM_MODE_CELL_STD];
        }
        
        if (cell == nil) {
            cell = [[SKSystemModeStdTableViewCell alloc] initWithFrame:CGRectZero];
        }
        
        ((SKSystemModeStdTableViewCell *)cell).tableViewController = self;
        ((SKSystemModeStdTableViewCell *)cell).entity = cellEntity;
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
    if(scenarios.count == 0 && systemModes.count < 2)
        return 0;
    else if(scenarios.count > 0 && systemModes.count > 1)
        return 2;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger entityType = [self getEntityTypeForSection:section];
    
    if(entityType == ENTITY_TYPE__SYSTEM_MODE)
        return NSLocalizedStringFromTable(@"System mode", @"Texts", nil);
    else if(entityType == ENTITY_TYPE__SCENARIO)
        return NSLocalizedStringFromTable(@"Scenario", @"Texts", nil);
    return NSLocalizedStringFromTable(@"Unknown", @"Texts", nil);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger entityType = [self getEntityTypeForSection:section];
    
    if(entityType == ENTITY_TYPE__SCENARIO)
        return scenarios.count;
    else if (entityType == ENTITY_TYPE__SYSTEM_MODE)
        return systemModes.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKEntity *entity;
    NSInteger entityType = [self getEntityTypeForSection:indexPath.section];
    
    if(entityType == ENTITY_TYPE__SCENARIO)
        entity = (SKScenario *)[scenarios objectAtIndex:indexPath.row];
    else if (entityType == ENTITY_TYPE__SYSTEM_MODE)
        entity = (SKSystemMode *)[systemModes objectAtIndex:indexPath.row];
    
    // Dequeue or create
    UITableViewCell *cell = [self dequeueOrCreateTableViewCell:tableView :entity];
    
    if([entity isKindOfClass:[SKScenario class]])
    {
        cell.tag = indexPath.row;
    } else if([entity isKindOfClass:[SKSystemMode class]]) {
        cell.tag = indexPath.row;
    } else {
        cell.tag = -1;
    }
    
    [self setTableViewCellData:cell :entity];
    
    return cell;
}


// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableViewCell *)cell :(SKEntity *)cellEntity {
    if([cell isKindOfClass:[SKScenarioStdTableViewCell class]]) {
        SKScenarioStdTableViewCell *scenarioCell = (SKScenarioStdTableViewCell *)cell;
        SKScenario *scenario = (SKScenario *)cellEntity;
        
        [scenarioCell.entityNameLabel setText:scenario.Name];
        
        if([XML_VALUE__TRUE isEqualToString:scenario.Active]) {
            [scenarioCell.entityIconImageView setHidden:false];
        } else {
            [scenarioCell.entityIconImageView setHidden:true];
        }
    } else if([cell isKindOfClass:[SKSystemModeStdTableViewCell class]]) {
        SKSystemModeStdTableViewCell *systemModeCell = (SKSystemModeStdTableViewCell *)cell;
        SKSystemMode *systemMode = (SKSystemMode *)cellEntity;
        
        [systemModeCell.entityNameLabel setText:systemMode.Name];
        
        if([XML_VALUE__TRUE isEqualToString:systemMode.Active]) {
            [systemModeCell.entityIconImageView setHidden:false];
        } else {
            [systemModeCell.entityIconImageView setHidden:true];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger entityType = [self getEntityTypeForSection:indexPath.section];
    
    if(cell.tag > -1) {
        if(entityType == ENTITY_TYPE__SCENARIO) {
            SKEntity *entity = (SKEntity *)[scenarios objectAtIndex:cell.tag];
        
            if([entity isKindOfClass:[SKScenario class]]) {
                [self performAction:(SKScenario *)entity];
            }
        } else if(entityType == ENTITY_TYPE__SYSTEM_MODE) {
            SKEntity *entity = (SKEntity *)[systemModes objectAtIndex:cell.tag];
            
            if([entity isKindOfClass:[SKSystemMode class]]) {
                [self performAction:(SKSystemMode *)entity];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%@", @"SCROLL");
}

- (NSInteger)getEntityTypeForSection:(NSInteger) section {
    if(systemModes.count > 1 && scenarios.count > 0) {
        if(section == 0)
            return ENTITY_TYPE__SYSTEM_MODE;
        else
            return ENTITY_TYPE__SCENARIO;
    } else if(systemModes.count > 1 && scenarios.count == 0) {
        return ENTITY_TYPE__UNKWNOWN;
    } else {
        return ENTITY_TYPE__SCENARIO;
    }
}

#pragma mark - View lifecycle

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end