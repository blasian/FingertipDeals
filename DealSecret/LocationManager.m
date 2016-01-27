//
//  LocationManager.m
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "LocationManager.h"
#import "User.h"


const float kLocationDistanceFilter = 1000.0f;

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSNumber* isUpdating;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.distanceFilter = kLocationDistanceFilter;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
        self.isUpdating = @NO;
        if ([self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
//        self.location = [[CLLocation alloc] initWithLatitude:49.207448 longitude:-123.124682];
    }
    return self;
}

+ (LocationManager*)sharedInstance {
    static LocationManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,  ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
    self.isUpdating = @NO;
}

- (void)start {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if (!self.isUpdating.boolValue) {
        [self.locationManager startUpdatingLocation];
        self.isUpdating = @YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Updated Location");
    self.location = locations.lastObject;
    NSMutableArray* params = [NSMutableArray new];
    for (CLLocation *location in locations) {
        NSDictionary *locDict = @{@"um_lat":[NSNumber numberWithFloat:location.coordinate.latitude],
                                  @"um_lon":[NSNumber numberWithFloat:location.coordinate.longitude]};
        [params addObject:locDict];
    }
    [User updateUserWithLocation:params
                           block:nil];
}

@end
