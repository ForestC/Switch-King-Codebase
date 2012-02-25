//
//  QuickActionsModeViewController.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickActionsModeViewController.h"
#import "SettingsMgr.h"

@implementation QuickActionsModeViewController


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    NSInteger cellCount = [self.tableView numberOfRowsInSection:0];
    NSInteger selectedValue = [SettingsMgr quickActionMode];
    
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
    
    [SettingsMgr setQuickActionMode:selectedCell.tag];
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
