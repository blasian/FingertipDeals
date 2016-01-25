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
#import "DealViewController.h"

@interface DealsMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) Deal *selectedDeal;

@end

@implementation DealsMapViewController

- (void)fetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Deal"];
    NSSortDescriptor *fetchSort = [NSSortDescriptor sortDescriptorWithKey:@"dealId" ascending:YES];
    if (self.category) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.title LIKE %@", self.category.title];
        [fetchRequest setPredicate:predicate];
    }
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
    
    if (!self.annotation_title) {
        self.annotation_title = @"Your Location";
    }
    if (!self.location) {
        self.location = [LocationManager sharedInstance].location;
    }
    
    // Map setup
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0f)];
    self.mapView.scrollEnabled = YES;
    if (!self.location)
        self.location = [LocationManager sharedInstance].location;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.05f, .05f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(self.location.coordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    
    // Navigation Button Setup
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, self.mapView.frame.origin.y + self.mapView.frame.size.height, self.view.frame.size.width, 50.0f)];
    self.nextButton.backgroundColor = [UIColor grayColor];
    [self.nextButton setTitle:@"Go to deal" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(navigateToDeal) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.mapView];
    
    [self refreshDeals];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Deal class]]) {
        self.selectedDeal = view.annotation;
        self.nextButton.backgroundColor = self.view.tintColor;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(nonnull MKAnnotationView *)view {
    self.selectedDeal = nil;
    self.nextButton.backgroundColor = [UIColor grayColor];
}

- (void)refreshDeals {
    if (!self.category) {
        [User getDealsWithLatitude:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude]
                         longitude:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude]
                             block:^(NSDictionary * _Nonnull response) {
                                 [self refreshAnnotations];
                             }];
    } else {
        [User getUserDealsWithCategory:self.category
                          withLatitude:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude]
                         withLongitude:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude]
                             withBlock:^(NSDictionary * _Nonnull response) {
            [self refreshAnnotations];
        }];
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"current"];
    pin.canShowCallout = YES;
    if ([annotation isKindOfClass:[Deal class]]) {
        pin.pinColor = MKPinAnnotationColorRed;
        UIButton *goToDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = goToDetail;
    } else {
        pin.pinColor = MKPinAnnotationColorGreen;
    }
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self navigateToDeal];
}

- (void)refreshAnnotations {
    [self fetch];
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.location.coordinate;
    annotation.title = self.annotation_title;
    [self.mapView setSelectedAnnotations:@[annotation]];
    [self.mapView addAnnotation:annotation];
    for (Deal *deal in self.deals) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(deal.latitude.floatValue, deal.longitude.floatValue);
        annotation.title = deal.header;
        [self.mapView addAnnotation:deal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)navigateToDeal {
    DealViewController *dealVC = [[DealViewController alloc] init];
    dealVC.deal = self.selectedDeal;
    [self.navigationController pushViewController:dealVC animated:YES];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
