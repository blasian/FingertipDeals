//
//  DealSubCategory+CoreDataProperties.h
//  DealSecret
//
//  Created by Michael Spearman on 12/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DealSubCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DealSubCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *preferred;
@property (nullable, nonatomic, retain) DealCategory *belongsTo;

@end

NS_ASSUME_NONNULL_END
