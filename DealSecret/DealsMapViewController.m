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
#import "DealsTableViewController.h"

@interface DealsMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) Deal *selectedDeal;

@end

@implementation DealsMapViewController

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
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.scrollEnabled = YES;
    if (!self.location)
        self.location = [LocationManager sharedInstance].location;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.05f, .05f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(self.location.coordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    
    // Navigation Button Setup
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.mapView.frame.size.width - 75.0f)/2, self.mapView.frame.size.height - 150.0f, 75.0f, 75.0f)];
    [self.nextButton setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(navigateToDeals) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.nextButton];
    
    [self refreshDeals];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Deal class]]) {
        self.selectedDeal = view.annotation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(nonnull MKAnnotationView *)view {
    self.selectedDeal = nil;
}

- (void)refreshDeals {
    if (!self.category) {
        [User getDealsWithLatitude:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude]
                         longitude:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude]
                             block:^(NSDictionary * _Nonnull response) {
                                 if (!response[@"error"]) {
                                     self.deals = response[@"deals"];
                                     [self refreshAnnotations];
                                 }
                             }];
    } else {
        [User getUserDealsWithCategory:self.category
                          withLatitude:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude]
                         withLongitude:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude]
                             withBlock:^(NSDictionary * _Nonnull response) {
                                 if (!response[@"error"]) {
                                     self.deals = response[@"deals"];
                                     [self refreshAnnotations];
                                 }
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
    NSString* dealId = ((Deal*)view.annotation).dealId;
    [self navigateToDeal:dealId];
}

- (void)navigateToDeal:(NSString*)dealId {
    DealViewController *dealVC = [[DealViewController alloc] init];
    dealVC.dealId = dealId;
    [self.navigationController pushViewController:dealVC animated:YES];
}


- (void)refreshAnnotations {
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
- (void)navigateToDeals {
    DealsTableViewController *dealsVC = [[DealsTableViewController alloc] init];
    [self.navigationController pushViewController:dealsVC animated:YES];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
