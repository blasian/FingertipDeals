//
//  DealViewController.h
//  DealSecret
//
//  Created by Michael Spearman on 12/2/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import "DealButtonStrip.h"

@class Deal;

@interface DealViewController : UIViewController <MKMapViewDelegate, ButtonStripDelegate>

@property (nonatomic, strong) Deal* deal;

@end
