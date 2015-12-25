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

@interface PreferencesTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *expandedSections;

@end

@implementation PreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.expandedSections = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed)];
    [self getSections];
    [self getUserSubSections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserSubSections {
    [User getUserClassesWithBlock:^(NSDictionary * _Nonnull response) {
        [self.tableView reloadData];
    }];
}

- (void)getSections {
    [User getCategoriesWithLevel:@1 withClass:nil withBlock:^(NSDictionary * _Nonnull response) {
        for (int i=0;i<[DealCategoryManager categories].count;i++) {
            [self.expandedSections addObject:@0];
        }
        [self.tableView reloadData];
    }];
}

- (void)getSubsectionsForSection:(NSString*)section withBlock:(void(^)())block {
    [User getCategoriesWithLevel:@2 withClass:section withBlock:^(NSDictionary * _Nonnull response) {
        if (block) {
            block();
        }
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BOOL isSelected = [self.expandedSections[indexPath.section]  isEqual: @1];
        self.expandedSections[indexPath.section] = isSelected ? @0 : @1;
        NSString* sectionName = [DealCategoryManager categoryWithIndex:indexPath.section].title;
        [self getSubsectionsForSection:sectionName withBlock:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else {
        DealSubCategory* subCat = [DealCategoryManager subCategoryWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        if (subCat.preferredBy == nil) {
            subCat.preferredBy = [User getMe];
        } else {
            subCat.preferredBy = nil;
        }
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
        length = [[DealCategoryManager subCategoriesForCategoryWithIndex:section] count] + 1;
    }
    
    return length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // disguise first cell as header cell for expanding
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"CategoryCell";
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100.0f)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.header.text = [DealCategoryManager categoryWithIndex:indexPath.section].title;
        cell.backgroundImage.image = [UIImage imageNamed:@"category-frame-green"];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    DealSubCategory *sub = [DealCategoryManager subCategoryWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
    if ([sub.preferredBy isEqual:[User getMe]]) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = sub.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110.0f;
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
