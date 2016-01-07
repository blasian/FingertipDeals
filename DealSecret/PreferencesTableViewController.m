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
        
        subCat.preferred = subCat.preferred.boolValue ? @NO : @YES;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [DealCategoryManager categoryWithIndex:indexPath.section].title;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DealSubCategory *sub = [DealCategoryManager subCategoryWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        cell.textLabel.text = sub.title;
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        if (sub.preferred.boolValue) {
            cell.checkView.image = [UIImage imageNamed:@"checkmark"];;
        } else {
            cell.checkView.image = [UIImage imageNamed:@"checkmark_unchecked"];
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
