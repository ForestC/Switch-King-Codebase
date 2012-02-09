//
//  ServerSettingsListViewController_iPhone.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerSettingsListViewController_iPhone.h"
#import "AppDelegate.h"
#include "Constants.h"
#import "SettingsMgr.h"
#import "TextSettingStdTableViewCell.h"
#import "SwitchSettingStdTableViewCell.h"
#import "AuthenticationDataContainer.h"

@implementation ServerSettingsListViewController_iPhone

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.communicationMgr requestUpdateOfAllEntities];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

/*******************************************************************************
 TextField Handling
 *******************************************************************************/

- (void)textFieldDidChange:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    
    if(
       cell.tag == CELL_TAG__USERNAME ||
       cell.tag == CELL_TAG__PASSWORD)
    {
        AuthenticationDataContainer *authContainer = [SettingsMgr getAuthenticationData];
        
        if(cell.tag == CELL_TAG__PASSWORD)
            [authContainer setPass:textField.text];
        else
            [authContainer setUser:textField.text];
        
        [SettingsMgr setAuthenticationData:authContainer];
    } else if(cell.tag == CELL_TAG__SERVER_ADDRESS) {
        [SettingsMgr setTargetAddress:textField.text:true];
    } else if(cell.tag == CELL_TAG__SERVER_IDENTITY) {
        [SettingsMgr setServerIdentity:[textField.text intValue]];
    } else if(cell.tag == CELL_TAG__SERVER_PORT) {
        [SettingsMgr setTargetPort:[textField.text intValue]];
    }
    
    [SettingsMgr setNeedServerVersionUpdate:true];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    
    Boolean useLive = [SettingsMgr useLive];
    
    switch (indexPath.section) {
        case TABLE_SECTION__SETTINGS__TARGET:
        {
            if(useLive) {
                if(indexPath.row == 1) {
                    NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:TABLE_SECTION__SETTINGS__CREDENTIALS];
                    TextSettingStdTableViewCell *cell = (TextSettingStdTableViewCell*)[self.tableView cellForRowAtIndexPath:sibling];
                    [cell.settingTextField becomeFirstResponder];
                }
            } else {
                if(indexPath.row == 1) {
                    NSIndexPath *sibling = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:TABLE_SECTION__SETTINGS__TARGET];
                    TextSettingStdTableViewCell *cell = (TextSettingStdTableViewCell*)[self.tableView cellForRowAtIndexPath:sibling];
                    [cell.settingTextField becomeFirstResponder];
                } else if(indexPath.row == 2) {
                    NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:TABLE_SECTION__SETTINGS__CREDENTIALS];
                    TextSettingStdTableViewCell *cell = (TextSettingStdTableViewCell*)[self.tableView cellForRowAtIndexPath:sibling];
                    [cell.settingTextField becomeFirstResponder];
                }
            }
            break;
        }
        case TABLE_SECTION__SETTINGS__CREDENTIALS:
        {
            if(indexPath.row == 0) {
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:TABLE_SECTION__SETTINGS__CREDENTIALS];
                TextSettingStdTableViewCell *cell = (TextSettingStdTableViewCell*)[self.tableView cellForRowAtIndexPath:sibling];
                [cell.settingTextField becomeFirstResponder];
            } else {
                [[self navigationController] popViewControllerAnimated:true];
            }
        }
    }
    
    return true;
}


/*******************************************************************************
 TableView Layout
 *******************************************************************************/

// Gets the expected tag by index path.
- (NSInteger)getExpectedTag:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0)
                return CELL_TAG__USE_LIVE;
            else if(indexPath.row == 1) {
                if([SettingsMgr useLive])
                    return CELL_TAG__SERVER_IDENTITY;
                else
                    return CELL_TAG__SERVER_ADDRESS;
            } else if(indexPath.row == 2) {
                return CELL_TAG__SERVER_PORT;
            }
            break;
            
        case 1:
            if(indexPath.row == 0)
                return CELL_TAG__USERNAME;
            else
                return CELL_TAG__PASSWORD;
            
        default:
            return -1;
            break;
    }
    
    return -1;
}

- (UITableViewCell *)dequeueOrCreateTableViewCell:(UITableView *)tableView: (NSInteger)tag {
    UITableViewCell *cell;
    
    switch (tag) {
        case CELL_TAG__PASSWORD:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_PASSWORD];
            break;
        case CELL_TAG__USERNAME:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_TEXT];
            break;
        case CELL_TAG__USE_LIVE:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_SWITCH];
            break;
        case CELL_TAG__SERVER_ADDRESS:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_URL];
            break;
        case CELL_TAG__SERVER_PORT:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_NUMERIC];
            break;
        case CELL_TAG__SERVER_IDENTITY:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    REUSE_IDENTIFIER__SETTINGS_CELL_NUMERIC];
            break;
        default:
            break;
    }
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    } else {
        cell.tag = tag;
    }
    
    return cell;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Two sections
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == TABLE_SECTION__SETTINGS__TARGET)
        return NSLocalizedStringFromTable(@"Target", @"Texts", nil);
    else
        return NSLocalizedStringFromTable(@"Credentials", @"Texts", nil);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if(section == TABLE_SECTION__SETTINGS__TARGET) {
        if(![SettingsMgr useLive] && [SettingsMgr getTargetPort] != 8800) {
            return NSLocalizedStringFromTable(@"Default port is 8800", @"Texts", nil);    
        }
    }
     
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if([SettingsMgr useLive])
                return 2;
            else
                return 3;
            break;
            
        default:
            return 2;
            break;
    }
}

// Called when rendering of a cell is requested
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Gets the expected tag
    NSInteger tag = [self getExpectedTag:indexPath];
    
    // Dequeue or create
    UITableViewCell *cell = [self dequeueOrCreateTableViewCell:tableView :tag];
    
    [self setTableViewCellData:tableView: cell];
    
    return cell;
}


// Sets the table view cell data depending on the type of cell and entity
- (void)setTableViewCellData:(UITableView *)tableView: (UITableViewCell *)cell {
    if(cell.tag == CELL_TAG__USERNAME) {
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Username", @"Texts", nil)];
        [settingsCell.settingTextField setText:[SettingsMgr getAuthenticationData].user];
        [settingsCell.settingTextField setPlaceholder:NSLocalizedStringFromTable(@"Username", @"Texts", nil)];
    } else if(cell.tag == CELL_TAG__PASSWORD) {
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Password", @"Texts", nil)];
        [settingsCell.settingTextField setText:[SettingsMgr getAuthenticationData].pass];
        [settingsCell.settingTextField setPlaceholder:NSLocalizedStringFromTable(@"Password", @"Texts", nil)];
        
        // Adjust the return key to "Done"
        [settingsCell.settingTextField setReturnKeyType:UIReturnKeyDone];
    } else if(cell.tag == CELL_TAG__USE_LIVE) {
        Boolean useLive = [SettingsMgr useLive];
        SwitchSettingStdTableViewCell *settingsCell = (SwitchSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Use Switch King Live", @"Texts", nil)];
        [settingsCell.settingSwitch setOn:useLive];
        [settingsCell.settingSwitch addTarget:self action:@selector(useLiveSwitchTouched:) forControlEvents:UIControlEventValueChanged];
        
    } else if(cell.tag == CELL_TAG__SERVER_ADDRESS) {
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Address", @"Texts", nil)];
        [settingsCell.settingTextField setText:[SettingsMgr getTargetAddress:false]];
        [settingsCell.settingTextField setPlaceholder:NSLocalizedStringFromTable(@"Server name or IP", @"Texts", nil)];        
    } else if(cell.tag == CELL_TAG__SERVER_PORT) {
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Port", @"Texts", nil)];
        
        [settingsCell.settingTextField setText:[NSString stringWithFormat:@"%d", [SettingsMgr getTargetPort]]];
        [settingsCell.settingTextField setPlaceholder:NSLocalizedStringFromTable(@"Port (default is 8800)", @"Texts", nil)];
    } else if(cell.tag == CELL_TAG__SERVER_IDENTITY) {
        NSString *identifier = [NSString stringWithFormat:@"%d", [SettingsMgr getServerIdentity]];
                                
        if([identifier isEqualToString:@"0"])
            identifier = @"";   
                                
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        [settingsCell.settingHeaderLabel setText:NSLocalizedStringFromTable(@"Server ID", @"Texts", nil)];
        
        [settingsCell.settingTextField setText:[NSString stringWithFormat:@"%d", [SettingsMgr getServerIdentity]]];
        [settingsCell.settingTextField setPlaceholder:NSLocalizedStringFromTable(@"Unique for your server", @"Texts", nil)];        
    }
    
    if([cell isKindOfClass:[TextSettingStdTableViewCell class]]) {
        TextSettingStdTableViewCell *settingsCell = (TextSettingStdTableViewCell *)cell;
        
        // Assign the delegate to handle responders, scroll into view, etc.
        [settingsCell.settingTextField setDelegate:self];
        
        // Add change listener
        [settingsCell.settingTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)useLiveSwitchTouched:(UIControl *)sender
{
    UISwitch *s = (UISwitch*)sender;
    
    [SettingsMgr setUseLive:s.on];
    
    [self.tableView reloadData];
}


@end
