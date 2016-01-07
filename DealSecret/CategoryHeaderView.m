//
//  CategoryHeaderView.m
//  DealSecret
//
//  Created by Michael Spearman on 1/5/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import "CategoryHeaderView.h"

@implementation CategoryHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tintColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


@end
