//
//  DealCategory.m
//  DealSecret
//
//  Created by Michael Spearman on 12/20/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealCategory.h"
#import "DealSubCategory.h"

@implementation DealCategory

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

//- (void)setIsPreferred:(NSNumber*)prefer {
//    self.isPreferred = prefer;
//    for (DealSubCategory* subcat in self.subCategories) {
//        subcat.isPreferred = prefer;
//        [subcat save];
//    }
//}

@end
