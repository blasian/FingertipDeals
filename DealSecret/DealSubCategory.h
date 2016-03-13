//
//  DealSubCategory.h
//  DealSecret
//
//  Created by Michael Spearman on 12/20/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedObject.h"

@class DealCategory, User;

NS_ASSUME_NONNULL_BEGIN

@interface DealSubCategory : ManagedObject

// Insert code here to declare functionality of your managed object subclass
- (id)initWithTitle:(NSString*)title withCategory:(DealCategory*)category;
@end

NS_ASSUME_NONNULL_END

#import "DealSubCategory+CoreDataProperties.h"
