//
//  DealCategoryManager.m
//  DealSecret
//
//  Created by Michael Spearman on 12/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "DealCategoryManager.h"
#import "DealCategory.h"
#import "DealSubCategory.h"
#import "User.h"
#import "NetworkManager.h"


@interface DealCategoryManager ()

@end

@implementation DealCategoryManager

+ (void)getCategoriesWithLevel:(NSNumber*)lnum
                     withClass:(NSString* _Nullable)cnum
                     withBlock:(void (^)(NSDictionary*))block {
    [[NetworkManager sharedInstance] GET:[NSString stringWithFormat:kUserCategoriesEndpoint, lnum, cnum] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *catDicts = responseObject[@"data"];
        for (NSDictionary* section in catDicts) {
            if (lnum.intValue == 1) {
                NSString *categoryTitle = section[@"c1_type"];
                
                NSManagedObjectContext* c = [ManagedObject context];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                          inManagedObjectContext:c];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", categoryTitle]];
                [fetchRequest setEntity:entity];
                NSError* error;
                DealCategory* category = nil;
                if ([c countForFetchRequest:fetchRequest
                                      error:&error] == 0) {
                    category = [[DealCategory alloc] initWithTitle:categoryTitle];
                    [category save];
                }
            }
            if (lnum.intValue == 2) {
                
                NSManagedObjectContext* c = [ManagedObject context];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                          inManagedObjectContext:c];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", cnum]];
                [fetchRequest setEntity:entity];
                NSError *error;
                if ([c countForFetchRequest:fetchRequest
                                      error:&error] == 1) {
                    DealCategory *category = [[[DealCategory context] executeFetchRequest:fetchRequest error:&error] firstObject];
                    NSString *subCategoryTitle = section[@"c2_type"];
                    entity = [NSEntityDescription entityForName:@"DealSubCategory"
                                         inManagedObjectContext:c];
                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@ AND category.title LIKE %@",
                                                subCategoryTitle, category.title]];
                    [fetchRequest setEntity:entity];
                    
                    NSError* error;
                    if ([c countForFetchRequest:fetchRequest
                                          error:&error] == 0) {
                        DealSubCategory* subCategory = [[DealSubCategory alloc] initWithTitle:subCategoryTitle withCategory:category];
                        [subCategory save];
                    }
                }
            }
        }
        if (block) {
            block(@{});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to retrieve sections");
        if (block) {
            block(@{@"error":error});
        }
    }];
}

+ (NSArray*)preferredCategories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:[DealSubCategory context]];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPreferred == YES"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sorting]];
    
    NSError *error = nil;
    NSArray *subCats = [[DealSubCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        NSMutableSet *result = [NSMutableSet set];
        for (DealSubCategory* subcat in subCats) {
            [result addObject:subcat.category];
        }
        return [result allObjects];
    }
}

+ (NSArray*)subCategories {
    return @[];
}


+ (void)getPreferredCategoriesWithBlock:(void (^)(NSDictionary*))block {
    [[NetworkManager sharedInstance] GET:kUserClassesEndpoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary* dict = responseObject[@"data"];
        for (NSDictionary* section in dict[@"user_class"]) {
            NSString *categoryTitle = section[@"c1_type"];
            NSString *subCategoryTitle = section[@"c2_type"];
            
            // check if c1_type exists
            // if no: create category with c1_type
            // check if c2_type exists with c1_type as belongsTo
            // if no: create subcategory with c2_type
            //        add category as belongsTo for subcategory
            
            NSManagedObjectContext* c = [ManagedObject context];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                      inManagedObjectContext:c];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", categoryTitle]];
            [fetchRequest setEntity:entity];
            NSError* error;
            DealCategory* category = nil;
            if ([c countForFetchRequest:fetchRequest
                                  error:&error] == 0) {
                category = [[DealCategory alloc] initWithTitle:categoryTitle];
                [category save];
            } else {
                category = [[c executeFetchRequest:fetchRequest error:&error] firstObject];
            }
            entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:c];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@ and category.title LIKE %@", subCategoryTitle, categoryTitle]];
            [fetchRequest setEntity:entity];
            DealSubCategory* subCategory = nil;
            if ([c countForFetchRequest:fetchRequest
                                  error:&error] == 0) {
                subCategory = [[DealSubCategory alloc] initWithTitle:subCategoryTitle withCategory:category];
            } else {
                subCategory = [[c executeFetchRequest:fetchRequest error:&error] firstObject];
            }
            subCategory.isPreferred = @YES;
            [subCategory save];
        }
        if (block) {
            block(@{});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to retrieve user classes");
        if (block) {
            block(@{@"error":error});
        }
    }];
}

+ (void)setPreferredCategoriesWithBlock:(void (^)(NSDictionary*))block {
    NSMutableArray *paramsArray = [NSMutableArray array];
    NSManagedObjectContext* c = [ManagedObject context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"DealSubCategory"
                                        inManagedObjectContext:c]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isPreferred == YES or category.isPreferred == YES"]];
    
    NSError* error;
    NSArray* results = [c executeFetchRequest:fetchRequest error:&error];
    
    for (DealSubCategory* subCat in results) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"c1_type"] = subCat.category.title;
        param[@"c2_type"] = subCat.title;
        [paramsArray addObject:param];
    }
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:paramsArray
                                                         options:0
                                                           error:&error];
    NSString* paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSDictionary *paramsDict = @{@"class":paramsString};
    
    [[NetworkManager sharedInstance] POST:kUserSetClassesEndpoint
                               parameters:paramsDict
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                      NSLog(@"updated user classes");
                                      NSLog(@"%@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:4]);
                                      if (block) {
                                          block(@{});
                                      }
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      NSLog(@"failed to update user classes");
                                      NSLog(@"%@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:4]);
                                      if (block) {
                                          block(@{@"error":error});
                                      }
                                  }];
}

+ (void)getSectionsWithBlock:(void(^)())block {
    [self getCategoriesWithLevel:@1 withClass:nil withBlock:^(NSDictionary * _Nonnull response) {
        if (block) {
            block();
        }
    }];
}

+ (void)getSubsectionsForSection:(NSString*)section withBlock:(void(^)())block {
    [self getCategoriesWithLevel:@2 withClass:section withBlock:^(NSDictionary * _Nonnull response) {
        if (block) {
            block();
        }
    }];
}

+ (NSArray*)preferredSubCategories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:[DealSubCategory context]];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPreferred == YES"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sorting]];
    
    NSError *error = nil;
    NSArray *result = [[DealSubCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        return result;
    }
}

+ (NSArray*)categories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory" inManagedObjectContext:[DealCategory context]];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sorting]];
    
    NSError *error = nil;
    NSArray *result = [[DealCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        return result;
    }
}

+ (DealCategory*)categoryWithIndex:(NSUInteger)index {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory" inManagedObjectContext:[DealCategory context]];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sorting]];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [[DealCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        return result[index];
    }
}

+ (DealSubCategory*)subCategoryWithIndexPath:(NSIndexPath*)indexPath {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    DealCategory* category = [self categoryWithIndex:indexPath.section];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:[DealCategory context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.title = %@", category.title];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sorting]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [[DealCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        return result[indexPath.row];
    }
}

+ (NSArray*)subCategoriesForCategoryWithIndex:(NSUInteger)index {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    DealCategory* category = [self categoryWithIndex:index];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:[DealCategory context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.title = %@", category.title];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sorting]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [[DealCategory context] executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    } else {
        return result;
    }
}


@end