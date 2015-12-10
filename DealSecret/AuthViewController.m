//
//  ViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 11/21/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "AuthViewController.h"
#import "AuthForm.h"
#import "User.h"
#import "DealsTableViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.formController.form = [[AuthForm alloc] init];
        self.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)validateEmail:(id)sender {
    FXFormTextFieldCell *cell = sender;
    
    NSString* reg = @"[^@]+@[^.@]+(\\.[^.@]+)+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    if (![emailTest evaluateWithObject:cell.textField.text]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)submitLoginForm:(id)sender {
    AuthForm *form = self.formController.form;
    NSString* email = form.login.email;
    NSString* password = form.login.password;
    
    NSLog(@"EMAIL %@ \n PASS %@", email, password);
    [User loginWithEmail:email withPassword:password block:^(NSDictionary * _Nonnull response) {
        NSLog(@"%@", response);
        if ([response valueForKey:@"error"] == nil) {
            DealsTableViewController *dealsVC = [[DealsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:dealsVC animated:YES];
        } else {
            NSLog(@"an error has occured");
        }
    }];
}

- (void)submitRegistrationForm:(id)sender {
    AuthForm *form = self.formController.form;
    NSString* email     = form.registration.email;
    NSString* password  = form.registration.password;
    NSString* firstName = form.registration.firstName;
    NSString* lastName  = form.registration.lastName;
    NSDate* birthdate   = form.registration.birthdate;
    NSNumber* gender    = form.registration.gender;
    
    NSMutableDictionary* params;
    
    if (email) {
        [params setObject:email forKey:@"user_email"];
    }
    
    if (password) {
        [params setObject:password forKey:@"user_password"];
    }
    
    NSLog(@"%@", params);
    [User createUserWithEmail:email withPassword:password block:^(NSDictionary * _Nonnull response) {
        NSLog(@"%@", response);
        if ([response valueForKey:@"error"] == nil) {
            DealsTableViewController *dealsVC = [[DealsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:dealsVC animated:YES];
        } else {
            NSLog(@"error registering account");
        }
    }];
}


@end
