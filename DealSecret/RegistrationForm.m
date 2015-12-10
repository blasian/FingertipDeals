//
//  RegistrationForm.m
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "RegistrationForm.h"

typedef NS_ENUM(NSInteger, Gender)
{
    GenderMale = 1,
    GenderFemale = 0,
    GenderOther = -1
};

@implementation RegistrationForm

- (NSDictionary *)passwordConfirmField
{
    return @{FXFormFieldTitle: @"Confirm"};
}

- (NSDictionary *)genderField
{
    return @{FXFormFieldOptions: @[@(GenderMale), @(GenderFemale), @(GenderOther)],
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@(GenderMale): @"Male",
                          @(GenderFemale): @"Female",
                          @(GenderOther): @"Other"}[input];
             }};
}

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"email", FXFormFieldHeader: @"Account"},
             @"password",
             @"passwordConfirm",
             @{FXFormFieldKey: @"firstName", FXFormFieldHeader: @"Details",
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             @{FXFormFieldKey: @"lastName",
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             @"birthdate",
             @"gender",
             @{FXFormFieldTitle: @"Register", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

@end
