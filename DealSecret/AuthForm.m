//
//  AuthForm.m
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "AuthForm.h"

@implementation AuthForm

- (NSDictionary *)loginField
{
    return @{FXFormFieldInline: @YES};
}

- (NSDictionary *)registrationField
{
    return @{FXFormFieldHeader: @"Not Registered?", FXFormFieldTitle: @"Sign up now!"};
}

@end
