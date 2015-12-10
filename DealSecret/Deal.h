//
//  Deal.h
//  DealSecret
//
//  Created by Michael Spearman on 11/24/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "ManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Deal : ManagedObject

- (instancetype)initWithAttributes:(NSDictionary*)attributes;

/**
 * The deal's distance from user.
 *
 * @return NSNumber distance in meters.
 */
- (NSNumber*)distance;


@end

NS_ASSUME_NONNULL_END

#import "Deal+CoreDataProperties.h"
