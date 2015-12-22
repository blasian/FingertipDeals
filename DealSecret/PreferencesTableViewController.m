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

@interface PreferencesTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *expandedSections;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation PreferencesTableViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeFetchResultsController];
    }
    return self;
}


- (void)initializeFetchResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DealCategory"];
    NSSortDescriptor *fetchSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[fetchSort]];
    NSManagedObjectContext *c = [ManagedObject context];
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:c sectionNameKeyPath:@"title" cacheName:nil]];
    [self.fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.expandedSections = [NSMutableArray array];
    for (int i=0;i<self.fetchedResultsController.sections.count;i++) {
        [self.expandedSections addObject:@0];
    }

    [self getSections];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSections {
    [User getCategoriesWithLevel:@1 withClass:nil withBlock:^(NSDictionary * _Nonnull response) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        int isSelected = self.expandedSections[indexPath.section].intValue;
        self.expandedSections[indexPath.section] = isSelected ? @0 : @1;
        NSString *sectionName = self.fetchedResultsController.sections[indexPath.section].name;
        [self getSubsectionsForSection:sectionName withBlock:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else {
        // select row
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger length = 1;
    if (self.expandedSections[section].intValue == 1) {
        length = [self.fetchedResultsController.sections[section] objects].count;
    }
    
    return length;
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CategoryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.0f)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.header.text = self.fetchedResultsController.sections[section].name;
    cell.backgroundImage.image = [UIImage imageNamed:@"category-frame-green"];
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // disguise first cell as header cell for expanding
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"CategoryCell";
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.0f)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.header.text = self.fetchedResultsController.sections[indexPath.section].name;
        cell.backgroundImage.image = [UIImage imageNamed:@"category-frame-green"];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    DealSubCategory *sub = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = sub.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110.0f;
    }
    return 50.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
