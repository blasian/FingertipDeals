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

@implementation DealCategoryManager

// returns array of categories that are preferred by the the user
+ (NSArray*)preferredSubCategories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:[DealSubCategory context]];
    NSSortDescriptor *sorting = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"preferred == YES"];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsTo.title = %@", category.title];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsTo.title = %@", category.title];
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

