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

- (instancetype)initWithTitle:(NSString*)title withCategory:(DealCategory*)category
{
    self = [super init];
    if (self) {
        self.title = title;
        self.category = category;
        [self addObserver:self forKeyPath:@"category.isPreferred"
                  options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"category.isPreferred"]) {
        NSNumber *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue != nil && ![newValue isEqual:[NSNull null]]) {
            if (newValue.boolValue != oldValue.boolValue) {
                [self setIsPreferred:newValue];
            }
        }
    }
}

@end
