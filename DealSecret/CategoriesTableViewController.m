//
//  DealsTableViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 11/24/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "DealsHeaderView.h"
#import "DealViewController.h"
#import "SettingsTableViewController.h"
#import "ZipViewController.h"
#import "LocationManager.h"
#import "Deal.h"
#import "User.h"
#import "CategoryTableViewCell.h"
#import "DealsTableViewController.h"
#import "DealsMapViewController.h"
#import "DealCategoryManager.h"
#import "DealCategory.h"
#import "DealSubCategory.h"
#import "UIImageView+AFNetworking.h"

const CGFloat kDealsNumberOfPages = 5;
const CGFloat kNumberOfStaticCells = 3;
const CGFloat kDealsHeaderSize = 180.0f;
const CGFloat kDealsCategoryCellHeight = 100.0f;

@interface CategoriesTableViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSArray<DealCategory*> *categories;

@end

@implementation CategoriesTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self getAllDealsWithBlock:^{
            [self initializeFetchResultsController];
        }];
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

- (void)viewWillAppear:(BOOL)animated {
    [self getHeaderDeals:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fingertip Deals";
    self.navigationController.navigationBarHidden = NO;
    UIImage *settingsImage = [UIImage imageNamed:@"settings_icon"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonTapped)];
    
    // Setup tableview header.
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.view.frame.size.width,
                                                                     kDealsHeaderSize)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * kDealsNumberOfPages,
                                             kDealsHeaderSize);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    self.contentArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < kDealsNumberOfPages; i++) {
        DealsHeaderView* headerView = [[DealsHeaderView alloc] initWithFrame:self.scrollView.bounds];
        CGRect frame = headerView.frame;
        frame.origin.x = i * self.scrollView.frame.size.width;
        headerView.frame = frame;
        [self.contentArray addObject:headerView];
        [self.scrollView addSubview:headerView];
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                       kDealsHeaderSize - 20.0f,
                                                                       self.view.bounds.size.width,
                                                                       20.0f)];
    self.pageControl.numberOfPages = kDealsNumberOfPages;
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:206.0/255 green:230.0/255 blue:240.0/255 alpha:1.0];
    
    [self.tableView addSubview:self.pageControl];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"form_background"]];
    self.tableView.tableHeaderView = self.scrollView;
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tag = 1;
    
    [User getUserClassesWithBlock:^(NSDictionary * _Nonnull response) {
        NSMutableArray *catsDupe = [NSMutableArray array];
        for (DealSubCategory* pref in [DealCategoryManager preferredSubCategories]) {
            [catsDupe addObject:pref.belongsTo];
        }
        NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:catsDupe];
        self.categories = [set array];
        [self.tableView reloadData];
    }];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [User getUserClassesWithBlock:^(NSDictionary * _Nonnull response) {
        NSMutableArray *catsDupe = [NSMutableArray array];
        for (DealSubCategory* pref in [DealCategoryManager preferredSubCategories]) {
            [catsDupe addObject:pref.belongsTo];
        }
        NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:catsDupe];
        self.categories = [set array];
        [self.tableView reloadData];
    }];
}
*/

- (void)settingsButtonTapped {
    SettingsTableViewController *settingsVC = [[SettingsTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)getAllDealsWithBlock:(void(^)())block {
    CLLocationCoordinate2D location = [LocationManager sharedInstance].location.coordinate;
    NSString* latitude = [NSString stringWithFormat:@"%f", location.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f", location.longitude];
    [User getDealsWithLatitude:latitude longitude:longitude block:^(NSDictionary * _Nonnull response) {
        if (block) {
            block();
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    [self getAllDealsWithBlock:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = indexOfPage;
    [self getHeaderDeals:indexOfPage];
}

- (void)getHeaderDeals:(int)index {
    if (self.contentArray.count > index) {
        if ([[[self fetchedResultsController] fetchedObjects] count] > index) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DealsHeaderView *header = self.contentArray[index];
                Deal *deal = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:index];
                [header.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cms.fingertipdeals.com/%@", deal.imageUrl]]];
                header.smallTitleLabel.text = deal.content;
            });
        } else {
            [self getAllDealsWithBlock:^{
                [self getHeaderDeals:index];
            }];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* preferredSubCategories = [DealCategoryManager preferredSubCategories];
    NSMutableSet *set = [NSMutableSet set];
    for (DealSubCategory* subCat in preferredSubCategories) {
        DealCategory *cat = subCat.belongsTo;
        [set addObject:cat.title];
    }
    return [set count] + kNumberOfStaticCells;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CategoryTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kDealsCategoryCellHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *header;
    NSString *subHeader;
    UIImage *image;
    UIImage *background;
    
    // Set up the cell
    switch (indexPath.row) {
        case 0:
            header = @"Current Deals";
            subHeader = @"Near You";
            image = [UIImage imageNamed:@"lightening"];
            background = [UIImage imageNamed:@"category-frame-green"];
            break;
        case 1:
            header = @"Location Deals";
            subHeader = @"Choose Your Location";
            image = [UIImage imageNamed:@"map-marker"];
            background = [UIImage imageNamed:@"category-frame-yellow"];
            break;
        case 2:
            header = @"All Deals";
            subHeader = @"Around You";
            image = [UIImage imageNamed:@"map"];
            background = [UIImage imageNamed:@"category-frame-teal"];
            break;
        default:
            header = self.categories[indexPath.row - 3].title;
            subHeader = @"Near you";
            image = [UIImage imageNamed:@"utensiles"];
            background = [UIImage imageNamed:@"category-frame-dark-blue"];
            break;
    }

    cell.header.text = header;
    cell.subHeader.text = subHeader;
    cell.icon.image = image;
    cell.backgroundImage.image = background;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDealsCategoryCellHeight + 5.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[DealsTableViewController alloc] init];
            break;
        case 1:
            vc = [[ZipViewController alloc] init];
            break;
        case 2:
            vc = [[DealsMapViewController alloc] init];
            ((DealsMapViewController*)vc).location = [LocationManager sharedInstance].location;
            break;
        default:
            vc = [[DealsMapViewController alloc] init];
            ((DealsMapViewController*)vc).location = [LocationManager sharedInstance].location;
            ((DealsMapViewController*)vc).category = self.categories[indexPath.row-3];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
