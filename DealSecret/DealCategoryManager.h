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
+ (NSArray*)subCategories;
+ (NSArray*)subCategoriesForCategoryWithIndex:(NSUInteger)index;
+ (NSArray*)preferredSubCategories;
+ (NSArray*)preferredCategories;

+ (DealCategory*)categoryWithIndex:(NSUInteger)index;
+ (DealSubCategory*)subCategoryWithIndexPath:(NSIndexPath*)indexPath;

+ (void)getSectionsWithBlock:(void(^)())block;
+ (void)getSubsectionsForSection:(NSString*)section withBlock:(void(^)())block;
+ (void)getPreferredCategoriesWithBlock:(void (^)(NSDictionary*))block;
+ (void)setPreferredCategoriesWithBlock:(void (^)(NSDictionary*))block;

@end
