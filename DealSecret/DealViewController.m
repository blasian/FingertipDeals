//
//  DealViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/2/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealViewController.h"
#import "Deal.h"
#import "LocationManager.h"

@interface DealViewController ()

@property IBOutlet MKMapView* mapView;
@property IBOutlet UIView* contentView;
@property IBOutlet UILabel* dealHeader;
@property IBOutlet UILabel* dealContent;
@property IBOutlet UILabel* dealDistance;

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dealHeader.text = self.deal.header;
    self.dealContent.text = self.deal.content;
    self.navigationController.navigationBarHidden = NO;
    // Setup map settings.
    self.mapView.delegate = self;
    CLLocationCoordinate2D dealCoordinate = CLLocationCoordinate2DMake([self.deal.latitude doubleValue], [self.deal.longitude doubleValue]);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.01f, .01f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(dealCoordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    MKPointAnnotation *dealAnnotation = [[MKPointAnnotation alloc] init];
    dealAnnotation.coordinate = dealCoordinate;
    dealAnnotation.title = @"Restaurant Name";
    [self.mapView addAnnotation:dealAnnotation];
    
    self.dealDistance.text = [NSString stringWithFormat:@"%d kms. away", self.deal.distance.intValue/1000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
