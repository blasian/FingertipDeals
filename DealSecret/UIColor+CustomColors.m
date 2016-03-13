//
//  UIColor+CustomColors.m
//  DealSecret
//
//  Created by Michael Spearman on 3/6/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)dealNotLikedColor {
    return [UIColor colorWithRed:231.0f/255.0f green:193.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dealLikedColor {
    return [UIColor colorWithRed:81.0f/255.0f green:152.0f/255.0f blue:57.0f/255.0f alpha:1.0];
}

@end
