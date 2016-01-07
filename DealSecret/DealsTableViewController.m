//
//  DealsTableViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealsTableViewController.h"
#import "Deal.h"
#import "DealTableViewCell.h"
#import "DealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkManager.h"
#import "DealCategoryManager.h"

const float kDealCellHeight = 100.0f;

@interface DealsTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation DealsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initializeFetchResultsController];
    }
    return self;
}

- (void)initializeFetchResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Deal"];
    NSSortDescriptor *fetchSort = [NSSortDescriptor sortDescriptorWithKey:@"dealId" ascending:YES];
    [fetchRequest setSortDescriptors:@[fetchSort]];
    NSManagedObjectContext *c = [ManagedObject context];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:c sectionNameKeyPath:nil cacheName:nil]];
    [self.fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Current Deals";
    self.navigationController.navigationBarHidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"DealTableViewCell" bundle:nil] forCellReuseIdentifier:@"DealCell"];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"form_background"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DealViewController *dealVC = [[DealViewController alloc] init];
    dealVC.deal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:dealVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell" forIndexPath:indexPath];
    
    Deal *deal = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    if (deal.imageUrl.length > 0) {
        [cell.companyImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cms.fingertipdeals.com/%@", deal.imageUrl]]];
    } else {
        cell.companyImage = nil;
    }
    cell.companyLabel.text = deal.header;
    cell.subtitleLabel.text = deal.content;
    NSString *distanceText;
    if (deal.distance.intValue < 500) {
        distanceText = [NSString stringWithFormat:@"%.2fm", deal.distance.floatValue];
    } else if (deal.distance.intValue < 100000) {
        distanceText = [NSString stringWithFormat:@"%.2fkm", deal.distance.floatValue / 1000.0];
    } else {
        distanceText = @"100+km";
    }
    cell.distanceLabel.text = [NSString stringWithFormat: @"%@", distanceText];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDealCellHeight + 15.0f;
}

#pragma mark - Navigation
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 } */

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

@end
