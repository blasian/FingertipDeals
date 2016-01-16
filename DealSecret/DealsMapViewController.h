//
//  DealsMapViewController.h
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@class Deal;
@class DealCategory;

@interface DealsMapViewController : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *annotation_title;
@property (nonatomic, strong) DealCategory *category;
@property (nonatomic, strong) NSArray<Deal*> *deals;

@end
