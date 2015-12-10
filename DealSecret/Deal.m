//
//  Deal.m
//  DealSecret
//
//  Created by Michael Spearman on 11/24/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "Deal.h"
#import "LocationManager.h"

@implementation Deal

- (instancetype)initWithAttributes:(NSDictionary*)attributes
{
    self = [super init];
    if (self) {
        // set attributes as values
        self.dealId = [attributes valueForKey:@"dm_no"];
        self.latitude = [attributes valueForKey:@"dm_lat"];
        self.longitude = [attributes valueForKey:@"dm_lon"];
        self.zip = [attributes valueForKey:@"dm_zip"];
        self.header = [attributes valueForKey:@"dm_header"];
        self.content = [attributes valueForKey:@"dm_content"];
        self.status = [NSNumber numberWithInt:[[attributes valueForKey:@"dm_status"] intValue]];
        self.imageUrl = [attributes valueForKey:@"dm_image"];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.startDate = [formatter dateFromString:[attributes valueForKey:@"dm_begdate"]];
        self.endDate = [formatter dateFromString:[attributes valueForKey:@"dm_enddate"]];
    }
    return self;
}

- (NSNumber*)distance {
    return [NSNumber numberWithFloat:[[[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]] distanceFromLocation:[LocationManager sharedInstance].location]];
}

@end
