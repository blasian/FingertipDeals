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

// Insert code here to add functionality to your managed object subclass

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

@end
