//
//  DealSubCategory.m
//  DealSecret
//
//  Created by Michael Spearman on 12/20/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealSubCategory.h"
#import "DealCategory.h"

@implementation DealSubCategory

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

@end
