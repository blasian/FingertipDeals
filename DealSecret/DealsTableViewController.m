//
//  DealsTableViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealsTableViewController.h"
#import "Deal.h"
#import "DealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkManager.h"
#import "LocationManager.h"
#import "DealCategoryManager.h"
#import "User.h"

const float kDealCellHeight = 100.0f;

@interface DealsTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) NSMutableArray* deals;
@property (nonatomic, strong) Deal* selectedDeal;

@end

@implementation DealsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        [self initializeFetchResultsController];
        self.location = [LocationManager sharedInstance].location;
    }
    return self;
}

- (void)shareButtonTapped:(DealTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedDeal = [self.deals objectAtIndex:indexPath.row];
    
    // UIActionSheet was depreciated in iOS 8.0 but Nikhil has iOS 7.x sooo...
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Share on Facebook",
                            @"Share on Twitter",
                            nil];
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* serviceType;
    switch (buttonIndex) {
        case 0:
            serviceType = SLServiceTypeFacebook;
            break;
        case 1:
            serviceType = SLServiceTypeTwitter;
            break;
        default:
            break;
    }
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    if (composeVC) {
        [composeVC setInitialText:self.selectedDeal.header];
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}

- (void)likeButtonTapped:(DealTableViewCell *)cell {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Deal has been liked."
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:nil];
    
    [message show];
}

/*
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
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
*/

- (void)dealSelected:(DealTableViewCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Current Deals";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[DealTableViewCell class] forCellReuseIdentifier:@"DealCell"];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"form_background"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self refreshDealsWithBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

-(void)refreshTable {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)refreshDealsWithBlock:(void (^)())block {
    [User getDealsWithLatitude:[NSString stringWithFormat:@"%f", [LocationManager sharedInstance].location.coordinate.latitude]
                     longitude:[NSString stringWithFormat:@"%f", [LocationManager sharedInstance].location.coordinate.longitude]
                         block:^(NSDictionary * _Nonnull response) {
                             if (!response[@"error"]) {
                                 self.deals = response[@"deals"];
                             }
                             if (block) {
                                 block();
                             }
                             [self refreshTable];
                         }];
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
    return self.deals.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DealViewController *dealVC = [[DealViewController alloc] init];
    dealVC.dealId = ((Deal*)self.deals[indexPath.row]).dealId;
    [self.navigationController pushViewController:dealVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell" forIndexPath:indexPath];
    if (!cell.delegate) {
        cell.delegate = self;
    }
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    if (deal.imageUrl.length > 0) {
        [cell.companyImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cms.fingertipdeals.com/%@", deal.imageUrl]]];
    } else {
        cell.companyImage.image = nil;
    }
    cell.dealLabel.text = deal.header;
//    cell.companyLabel.text = deal.content;
//    cell.subtitleLabel.text = @"";
    NSString *distanceText;
    if (deal.distance.intValue < 500) {
        distanceText = [NSString stringWithFormat:@"%.2fm", deal.distance.floatValue];
    } else if (deal.distance.intValue < 100000) {
        distanceText = [NSString stringWithFormat:@"%.1fkm", deal.distance.floatValue / 1000.0];
    } else {
        distanceText = @"100+km";
    }
    cell.distanceLabel.text = [NSString stringWithFormat: @"%@", distanceText];
    if (deal.distance.intValue > 5000) {
        cell.distanceMeterView.backgroundColor = [UIColor colorWithRed:182.0f/255.0f green:76.0f/255.0f blue:76.0f/255.0f alpha:0.9];
    } else {
        cell.distanceMeterView.backgroundColor = [UIColor colorWithRed:143.0f/255.0f green:174.0f/255.0f blue:36.0f/255.0f alpha:0.9];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDealCellHeight;
}

#pragma mark - Navigation
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
