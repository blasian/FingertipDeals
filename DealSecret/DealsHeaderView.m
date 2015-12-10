//
//  DealsHeaderView.m
//  DealSecret
//
//  Created by Michael Spearman on 11/26/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealsHeaderView.h"

@implementation DealsHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bigTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.frame.size.width,
                                                                       140.0f)];
        self.bigTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:78.0f];
        self.bigTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.bigTitleLabel.textColor = [UIColor blackColor];
        self.bigTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.bigTitleLabel];
        
        self.smallTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                         110.0f,
                                                                         self.frame.size.width,
                                                                         40.0f)];
        self.smallTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:22.0f];
        self.smallTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.smallTitleLabel.textColor = [UIColor blackColor];
        self.smallTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.smallTitleLabel];
    }
    
    
    return  self;
}

@end
