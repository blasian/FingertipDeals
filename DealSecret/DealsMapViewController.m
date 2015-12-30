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
#import "DealCategory.h"
#import "DealSubCategory.h"


@interface DealsMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation DealsMapViewController

- (void)fetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Deal"];
    NSSortDescriptor *fetchSort = [NSSortDescriptor sortDescriptorWithKey:@"dealId" ascending:YES];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category LIKE %@", self.category.title];
//    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[fetchSort]];
    NSManagedObjectContext *c = [ManagedObject context];
    
    NSError *error = nil;
    NSArray *result = [c executeFetchRequest:fetchRequest error:&error];
    if (!result) {
        NSLog(@"Failed to perform fetch for %@: %@\n%@", self.category.title, [error localizedDescription], [error userInfo]);
        abort();
    } else {
        self.deals = result;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Location Deals";
    self.navigationController.navigationBarHidden = NO;
    self.view = [[UIImageView alloc] initWithFrame:self.view.frame];
    ((UIImageView*)self.view).image = [UIImage imageNamed:@"form_background"];
    self.view.userInteractionEnabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshDeals)];
    
    // Map setup
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.scrollEnabled = YES;
    if (!self.location)
        self.location = [LocationManager sharedInstance].location;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.01f, .01f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(self.location.coordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    [self.view addSubview:self.mapView];
    
    [self refreshDeals];
}

- (void)refreshDeals {
    // this should call getDealsWithClass: withLat: withLon: withBlock:
    [User getDealsWithLatitude:[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude]
                     longitude:[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude] block:^(NSDictionary * _Nonnull response) {
        [self refreshAnnotations];
    }];
}

- (void)refreshAnnotations {
    [self fetch];
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (Deal *deal in self.deals) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(deal.latitude.floatValue, deal.longitude.floatValue);
        annotation.title = deal.header;
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
