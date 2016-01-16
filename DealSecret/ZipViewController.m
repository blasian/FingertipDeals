//
//  ZipViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 1/5/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import "ZipViewController.h"
#import "TextField.h"
#import "LocationManager.h"
#import "DealsMapViewController.h"

@interface ZipViewController ()

@property (nonatomic, strong) CLGeocoder* geo;
@property (nonatomic, strong) TextField* zipField;
@property (nonatomic, strong) UILabel* headerLabel;

@end

@implementation ZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.geo = [[CLGeocoder alloc] init];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"form_background"];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 100)];
    self.headerLabel.text = @"Choose your Location";
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.numberOfLines = 1;
    self.headerLabel.minimumScaleFactor = .2;
    self.headerLabel.adjustsFontSizeToFitWidth = YES;
    
    self.zipField = [[TextField alloc] initWithFrame:CGRectMake(10, self.headerLabel.frame.origin.y + 100, self.view.frame.size.width - 20, 50)];
    self.zipField.placeholder = @"Address";
    self.zipField.textAlignment = NSTextAlignmentCenter;
    self.zipField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.zipField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.zipField.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    
    [self.view addSubview:background];
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.zipField];
    [self.view addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundTapped {
    [self.view endEditing:YES];
}

- (void)next {
    CLCircularRegion* mapRegion = [[CLCircularRegion alloc] initWithCenter:[LocationManager sharedInstance].location.coordinate radius:10000 identifier:@"user"];
    [self.geo geocodeAddressString:self.zipField.text
                          inRegion:mapRegion
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                     if (!error) {
                         DealsMapViewController* mapVC = [[DealsMapViewController alloc] init];
                         mapVC.annotation_title = [placemarks firstObject].name;
                         mapVC.location = [placemarks firstObject].location;
                         [self.navigationController pushViewController:mapVC animated:YES];
                     } else {
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Address not found" message:error.debugDescription preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:ok];
                         
                         [self presentViewController:alertController animated:YES completion:nil];
                     }
                 }];
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
