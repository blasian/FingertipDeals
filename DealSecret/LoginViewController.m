//
//  LoginViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/10/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "TextField.h"
#import "CategoriesTableViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet TextField* emailField;
@property (nonatomic, weak) IBOutlet TextField* passwordField;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton* facebookButton;
@property (nonatomic, weak) IBOutlet UIButton* nextButton;
@property (nonatomic, weak) IBOutlet UIButton* forgotPasswordButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sign In";
    self.navigationController.navigationBarHidden = NO;
    [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)]];
    
    [self.forgotPasswordButton addTarget:self action:@selector(forgotPasswordTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.facebookButton.delegate = self;
}

- (void)forgotPasswordTapped:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What is your email?"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Reset", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *email = [alertView textFieldAtIndex:0].text;
        [User forgotPasswordWithEmail:email withBlock:^(NSDictionary * _Nonnull response) {
            
        }];
    }
}

#pragma mark Facebook Delegate Methods
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 // goto registration/login page depending on...
                 CategoriesTableViewController *dealsVC = [[CategoriesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                 [self.navigationController pushViewController:dealsVC animated:YES];
             } else {
                 // handle error
                 NSLog(@"error: %@", error);
             }
         }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonPressed {
    NSString* email = self.emailField.text;
    NSString* password = self.passwordField.text;
    
    NSLog(@"EMAIL %@ \n PASS %@", email, password);
    [User loginWithEmail:email withPassword:password block:^(NSDictionary * _Nonnull response) {
        NSLog(@"%@", response);
        if (!response) {
            CategoriesTableViewController *dealsVC = [[CategoriesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:dealsVC animated:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please fix error" message:[response valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)backgroundTapped {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
