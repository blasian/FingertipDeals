//
//  Deal+CoreDataProperties.h
//  DealSecret
//
//  Created by Michael Spearman on 1/17/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Deal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Deal (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *dealId;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSString *header;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *zip;
@property (nullable, nonatomic, retain) DealCategory *category;
@property (nullable, nonatomic, retain) DealSubCategory *subCategory;

@end

NS_ASSUME_NONNULL_END
