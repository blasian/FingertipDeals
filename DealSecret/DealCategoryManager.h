//
//  DealCategoryManager.h
//  DealSecret
//
//  Created by Michael Spearman on 12/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DealCategory;
@class DealSubCategory;

@interface DealCategoryManager : NSObject

+ (NSArray*)categories;
+ (NSArray*)preferredSubCategories;
+ (DealCategory*)categoryWithIndex:(NSUInteger)index;
+ (DealSubCategory*)subCategoryWithIndexPath:(NSIndexPath*)indexPath;
+ (NSArray*)subCategoriesForCategoryWithIndex:(NSUInteger)index;
+ (void)getSectionsWithBlock:(void(^)())block;
+ (void)getSubsectionsForSection:(NSString*)section withBlock:(void(^)())block;

@end
