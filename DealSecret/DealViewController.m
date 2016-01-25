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

@property MKMapView* mapView;
@property UIScrollView* scrollView;
@property UILabel* dealHeader;
@property UILabel* dealContent;
@property UILabel* dealDistance;
@property DealButtonStrip* dealStrip;

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"form_background"];
    
    // Setup map.
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, self.view.frame.size.width - 20.0, self.view.frame.size.height/3)];
    self.mapView.delegate = self;
    CLLocationCoordinate2D dealCoordinate = CLLocationCoordinate2DMake([self.deal.latitude doubleValue], [self.deal.longitude doubleValue]);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.01f, .01f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(dealCoordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    MKPointAnnotation *dealAnnotation = [[MKPointAnnotation alloc] init];
    dealAnnotation.coordinate = dealCoordinate;
    dealAnnotation.title = @"Restaurant Name";
    [self.mapView addAnnotation:dealAnnotation];
    
    // Setup button strip
    self.dealStrip = [[DealButtonStrip alloc] initWithFrame:CGRectMake(10.0f, self.mapView.frame.origin.y + self.mapView.frame.size.height + 10.0f, self.view.frame.size.width - 20.0f, 25.0f)];
    self.dealStrip.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    self.dealStrip.delegate = self;
    
    // setup Scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, self.dealStrip.frame.origin.y + self.dealStrip.frame.size.height + 10.0f, self.view.frame.size.width - 20.0f, self.view.frame.size.height - self.dealStrip.frame.origin.y - self.dealStrip.frame.size.height - 30.0f - 75.0f)];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    // setup header
    self.dealHeader = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.frame.size.width, 100.0f)];
    self.dealHeader.text = self.deal.header;
    self.dealHeader.textAlignment = NSTextAlignmentCenter;
    self.dealHeader.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealHeader.numberOfLines = 0;
    self.dealHeader.textColor = [UIColor whiteColor];
    [self heightToFit:self.dealHeader];
    
    // setup content
    self.dealContent = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.dealHeader.frame.origin.y + self.dealHeader.frame.size.height, self.scrollView.frame.size.width, 100.0f)];
    self.dealContent.text = self.deal.content;
    self.dealContent.textAlignment = NSTextAlignmentCenter;
    self.dealContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealContent.numberOfLines = 0;
    self.dealContent.textColor = [UIColor whiteColor];
    [self heightToFit:self.dealContent];
    
    // setup distance
    self.dealDistance = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.dealContent.frame.origin.y + self.dealContent.frame.size.height, self.scrollView.frame.size.width, 100.0f)];
    self.dealDistance.text = [NSString stringWithFormat:@"%d kms. away", self.deal.distance.intValue/1000];
    self.dealDistance.textAlignment = NSTextAlignmentCenter;
    self.dealDistance.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealDistance.numberOfLines = 0;
    self.dealDistance.textColor = [UIColor whiteColor];
    [self heightToFit:self.dealDistance];
    
    CGRect contentRect = CGRectZero;
    contentRect = CGRectUnion(contentRect, self.dealHeader.frame);
    contentRect = CGRectUnion(contentRect, self.dealContent.frame);
    contentRect = CGRectUnion(contentRect, self.dealDistance.frame);
//    contentRect.size.height -= 1.0f;
    
    [self.scrollView setContentSize:contentRect.size];
    
    // setup nextButton
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 75.0f)/2, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 10.0f, 75.0f, 75.0f)];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:background];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.dealStrip];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.dealHeader];
    [self.scrollView addSubview:self.dealContent];
    [self.scrollView addSubview:self.dealDistance];
    [self.view addSubview:backButton];
}

- (void)heightToFit:(UILabel*)label {
    CGRect minWidth = CGRectMake(label.frame.origin.x, label.frame.origin.x, self.view.frame.size.width - 20.0f, 1.0f);
    CGSize maxSize = CGSizeMake(self.view.frame.size.width - 20.0f, CGFLOAT_MAX);
    
    CGRect textRect = [label.text boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:label.font}
                                               context:nil];
    CGRect newRect = CGRectUnion(textRect, minWidth);
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, newRect.size.width, newRect.size.height+ 10.0f)];
}

#pragma mark ButtonStripDelegate Methods

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonPressed {

}

- (void)timerButtonPressed {
    
}

- (void)favButtonPressed {
    
}

- (void)likeButtonPressed {
    
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
