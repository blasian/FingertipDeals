//
//  LoginForm.m
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "LoginForm.h"
#import "FXForms.h"

@implementation LoginForm

- (NSArray*)fields {
    return @[@{FXFormFieldKey: @"email", FXFormFieldAction: @"validateEmail:"},
             @"password"
             ];
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Login", FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm:"}
             ];
}

@end
