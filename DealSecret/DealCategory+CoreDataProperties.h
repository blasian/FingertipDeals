//
//  DealCategory+CoreDataProperties.h
//  DealSecret
//
//  Created by Michael Spearman on 12/20/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DealCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DealCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) DealSubCategory *hasMany;

@end

NS_ASSUME_NONNULL_END
