//
//  RefreshAfterCommandListViewController.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RefreshAfterCommandListViewController.h"
#import "SettingsMgr.h"


@implementation RefreshAfterCommandListViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    NSInteger cellCount = [self.tableView numberOfRowsInSection:0];
    NSInteger selectedValue = [SettingsMgr getDeviceUpdateDelay];
    
    for (int i=0; i<cellCount; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(cell.tag == selectedValue)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger cellCount = [self.tableView numberOfRowsInSection:0];
    
    for (int i=0; i<cellCount; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(selectedCell != cell)
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [SettingsMgr setDeviceUpdateDelay:selectedCell.tag];
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
