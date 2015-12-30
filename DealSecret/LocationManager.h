//
//  LocationManager.h
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *location;

+ (LocationManager*)sharedInstance;
- (void)start;
- (void)stop;

@end
