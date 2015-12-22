//
//  SettingsTableViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/3/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SplashScreenViewController.h"
#import "Constants.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) NSArray* cellTitles;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.cellTitles = @[@"Preferences", @"Reset Password", @"Sign Out"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            // Preferences
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            // Forgot Password
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            // Sign Out
            break;
        default:
            break;
    }

    cell.textLabel.text = [self.cellTitles objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            // Preferences
            break;
        case 1:
            // Forgot Password
            break;
        case 2:
            // Sign Out
            [self signOut];
            break;
        default:
            break;
    }
}

#pragma mark - Actions
- (void)signOut {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kUserPersistenceKey];
    SplashScreenViewController *splash = [[SplashScreenViewController alloc] init];
    [self.navigationController pushViewController:splash animated:YES];
    self.navigationController.viewControllers = @[splash];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
