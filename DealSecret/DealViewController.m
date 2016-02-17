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
#import "User.h"


@interface DealViewController ()

@property MKMapView* mapView;
@property UIScrollView* scrollView;
@property UILabel* dealHeader;
@property UILabel* dealContent;
@property UILabel* dealDistance;
@property DealButtonStrip* dealStrip;
@property Deal* deal;
@property UIButton* backButton;

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [User getDealWithId:self.dealId block:^(NSDictionary * _Nonnull response) {
        // get dealid from core data
        NSManagedObjectContext* c = [ManagedObject context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deal"
                                                  inManagedObjectContext:c];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dealId == %@",
                                    self.dealId]];
        [fetchRequest setEntity:entity];
        NSError* error;
        NSArray *fetchedObjects = [c executeFetchRequest:fetchRequest error:&error];
        self.deal = [fetchedObjects firstObject];
        [self reloadDeal];
    }];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"form_background"];
    
    // Setup mapview
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, self.view.frame.size.width - 20.0, self.view.frame.size.height/3)];
    self.mapView.delegate = self;
    
    // Setup button strip
    self.dealStrip = [[DealButtonStrip alloc] initWithFrame:CGRectMake(10.0f, self.mapView.frame.origin.y + self.mapView.frame.size.height + 10.0f, self.view.frame.size.width - 20.0f, 25.0f)];
    self.dealStrip.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    self.dealStrip.delegate = self;
    
    // setup Scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, self.dealStrip.frame.origin.y + self.dealStrip.frame.size.height + 10.0f, self.view.frame.size.width - 20.0f, self.view.frame.size.height - self.dealStrip.frame.origin.y - self.dealStrip.frame.size.height - 30.0f - 75.0f)];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    // setup header
    self.dealHeader = [[UILabel alloc] init];
    self.dealHeader.textAlignment = NSTextAlignmentCenter;
    self.dealHeader.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealHeader.numberOfLines = 0;
    self.dealHeader.textColor = [UIColor whiteColor];
    
    // setup content
    self.dealContent = [[UILabel alloc] init];
    self.dealContent.textAlignment = NSTextAlignmentCenter;
    self.dealContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealContent.numberOfLines = 0;
    self.dealContent.textColor = [UIColor whiteColor];
    
    // setup distance
    self.dealDistance = [[UILabel alloc] init];
    self.dealDistance.textAlignment = NSTextAlignmentCenter;
    self.dealDistance.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealDistance.numberOfLines = 0;
    self.dealDistance.textColor = [UIColor whiteColor];

    
    // setup nextButton
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:background];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.dealStrip];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.dealHeader];
    [self.scrollView addSubview:self.dealContent];
    [self.scrollView addSubview:self.dealDistance];
    [self.view addSubview:self.backButton];
}

- (void)reloadDeal {
    // Setup map.
    CLLocationCoordinate2D dealCoordinate = CLLocationCoordinate2DMake([self.deal.latitude doubleValue], [self.deal.longitude doubleValue]);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.01f, .01f);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(dealCoordinate, mapSpan);
    [self.mapView setRegion:mapRegion animated:YES];
    MKPointAnnotation *dealAnnotation = [[MKPointAnnotation alloc] init];
    dealAnnotation.coordinate = dealCoordinate;
    dealAnnotation.title = @"Restaurant Name";
    [self.mapView addAnnotation:dealAnnotation];
    
    self.dealHeader.frame = CGRectMake(0.0f, 0.0f, self.scrollView.frame.size.width, 100.0f);
    self.dealHeader.text = self.deal.header;
    [self heightToFit:self.dealHeader];
    
    self.dealContent.frame = CGRectMake(0.0f, self.dealHeader.frame.origin.y + self.dealHeader.frame.size.height, self.scrollView.frame.size.width, 100.0f);
    self.dealContent.text = self.deal.content;
    [self heightToFit:self.dealContent];
    
    self.dealDistance.frame = CGRectMake(0.0f, self.dealContent.frame.origin.y + self.dealContent.frame.size.height, self.scrollView.frame.size.width, 100.0f);
    self.dealDistance.text = [NSString stringWithFormat:@"%d kms. away", self.deal.distance.intValue/1000];
    [self heightToFit:self.dealDistance];
    
    CGRect contentRect = CGRectZero;
    contentRect = CGRectUnion(contentRect, self.dealHeader.frame);
    contentRect = CGRectUnion(contentRect, self.dealContent.frame);
    contentRect = CGRectUnion(contentRect, self.dealDistance.frame);
    //    contentRect.size.height -= 1.0f;
    [self.scrollView setContentSize:contentRect.size];
    
    self.backButton.frame = CGRectMake((self.view.frame.size.width - 75.0f)/2, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 10.0f, 75.0f, 75.0f);
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
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
        [composeVC setInitialText:self.deal.header];
        [self presentViewController:composeVC animated:YES completion:nil];
    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error sharing your content, please ensure that you have internet connection." preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
    }
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
