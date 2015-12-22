//
//  DealsMapViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealsMapViewController.h"
#import "LocationManager.h"
#import "Deal.h"
#import "User.h"

@interface DealsMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation DealsMapViewController

- (instancetype)init
{
    self = [super init];
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
    self.title = @"Location Deals";
    self.navigationController.navigationBarHidden = NO;
    self.view = [[UIImageView alloc] initWithFrame:self.view.frame];
    ((UIImageView*)self.view).image = [UIImage imageNamed:@"form_background"];
    self.view.userInteractionEnabled = YES;
    
    // Map setup
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.height - 100.0f)];
    self.mapView.scrollEnabled = YES;
    if (!self.location)
        self.location = [LocationManager sharedInstance].location;
    self.mapView.delegate = self;
//    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.showsUserLocation = YES;
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.01f, .01f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(self.location.coordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    [self.view addSubview:self.mapView];
    
    [self loadDeals];
}

- (void)loadDeals {
    [User getDealsWithLatitude:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude] block:^(NSDictionary * _Nonnull response) {
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self addAnnotations];
    }];
}

- (void)addAnnotations {
    NSArray* deals = [self.fetchedResultsController fetchedObjects];
    for (Deal *deal in deals) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(deal.latitude.floatValue, deal.longitude.floatValue);
        annotation.title = deal.header;
        MKCoordinateRegion mapRegion = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(.01f, .01f));
        [self.mapView setRegion:mapRegion];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
