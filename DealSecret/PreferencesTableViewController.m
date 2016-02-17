//
//  PreferencesTableViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/19/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "PreferencesTableViewController.h"
#import "CategoryTableViewCell.h"
#import "User.h"
#import "DealCategory.h"
#import "DealSubCategory.h"
#import "DealCategoryManager.h"
#import "CategoriesTableViewController.h"
#import "SubCategoryTableViewCell.h"

@interface PreferencesTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *expandedSections;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *allSelected;

@end

@implementation PreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HeaderCell"];
    [self.tableView registerClass:[SubCategoryTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.expandedSections = [NSMutableArray array];
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed)];
    [DealCategoryManager getSectionsWithBlock:^{
        for (int i=0;i<[DealCategoryManager categories].count;i++) {
            [self.expandedSections addObject:@0];
            [self.allSelected addObject:@0];
        }
        [self.tableView reloadData];
    }];
    [self getPreferredSubSections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPreferredSubSections {
    [User getUserClassesWithBlock:^(NSDictionary * _Nonnull response) {
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BOOL isSelected = [self.expandedSections[indexPath.section]  isEqual: @1];
        self.expandedSections[indexPath.section] = isSelected ? @0 : @1;
        NSString* sectionName = [DealCategoryManager categoryWithIndex:indexPath.section].title;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        int originalLength = [[DealCategoryManager subCategoriesForCategoryWithIndex:indexPath.section] count];
        [DealCategoryManager getSubsectionsForSection:sectionName withBlock:^{
            if (originalLength != [[DealCategoryManager subCategoriesForCategoryWithIndex:indexPath.section] count]) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    } else if (indexPath.row == 1) {
        DealCategory* cat = [DealCategoryManager categoryWithIndex:indexPath.section];
        cat.isPreferred = cat.isPreferred.boolValue ? @NO : @YES;
        [cat save];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        DealSubCategory* subCat = [DealCategoryManager subCategoryWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 2 inSection:indexPath.section]];
        subCat.isPreferred = subCat.isPreferred.boolValue ? @NO : @YES;
        [subCat save];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.expandedSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger length = 1;
    if (self.expandedSections[section].intValue == 1) {
        length = [[DealCategoryManager subCategoriesForCategoryWithIndex:section] count] + 2;
    }
    
    return length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // disguise first cell as header cell for expanding
    if (indexPath.row == 0) {
        SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [DealCategoryManager categoryWithIndex:indexPath.section].title;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.checkView.image = self.expandedSections[indexPath.section].boolValue ? [UIImage imageNamed:@"checkmark"] : [UIImage imageNamed:@"checkmark_unchecked"];
        return cell;
    } else {
        SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 1) {
            cell.textLabel.text = @"All";
            DealCategory* cat = [DealCategoryManager categoryWithIndex:indexPath.section];
            cell.checkView.image = cat.isPreferred.boolValue ? [UIImage imageNamed:@"checkmark"] : [UIImage imageNamed:@"checkmark_unchecked"];
        } else {
            DealSubCategory *sub = [DealCategoryManager subCategoryWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 2 inSection:indexPath.section]];
            cell.textLabel.text = sub.title;
            cell.checkView.image = sub.isPreferred.boolValue ? [UIImage imageNamed:@"checkmark"] : [UIImage imageNamed:@"checkmark_unchecked"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 75.0;
    }
    return 50.0;
}


#pragma mark - Navigation

- (void)nextButtonPressed {
    [User setUserClassesWithBlock:^(NSDictionary * _Nonnull response) {
        CategoriesTableViewController *catVC = [[CategoriesTableViewController alloc] init];
        [self.navigationController pushViewController:catVC animated:YES];
    }];
}

@end
