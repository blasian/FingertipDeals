//
//  DealViewController.h
//  DealSecret
//
//  Created by Michael Spearman on 12/2/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Deal;

@interface DealViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) Deal* deal;

@end
