//
//  AuthForm.h
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "LoginForm.h"
#import "RegistrationForm.h"

@interface AuthForm : NSObject<FXForm>

@property (nonatomic, strong) LoginForm *login;
@property (nonatomic, strong) RegistrationForm *registration;

@end
