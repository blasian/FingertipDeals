//
//  TermsPopUpView.m
//  DealSecret
//
//  Created by Michael Spearman on 3/29/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import "TermsPopUpView.h"

@implementation TermsPopUpView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef termsText = UIGraphicsGetCurrentContext();
    CGContextSaveGState(termsText);
    CGContextSetShadow(termsText, CGSizeMake(-15, 20), 5);
    [super drawRect: rect];
    CGContextRestoreGState(termsText);
}

@end
