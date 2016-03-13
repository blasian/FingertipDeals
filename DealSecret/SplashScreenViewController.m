//
//  SplashScreenViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/10/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "CategoriesTableViewController.h"
#import "PreferencesTableViewController.h"
#import <Accounts/Accounts.h>
#import "User.h"
#import <Social/Social.h>
#import "Constants.h"

@interface SplashScreenViewController ()

@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton *facebookButton;
@property (nonatomic, strong) TWTRLogInButton *twitterButton;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.titleLabel.textColor = [UIColor whiteColor];
    self.registerButton.titleLabel.textColor = [UIColor whiteColor];
    self.facebookButton.delegate = self;
    [self.signInButton addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.twitterButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        NSLog(@"logging..");
        if (session) {
            [User loginWithEmail:[NSString stringWithFormat:@"%@@twitter.com", session.userName] withSource:@"twitter" block:^(NSDictionary * _Nonnull response) {
                
                if (!response) {
                    self.twitterButton.enabled = YES;
                    CategoriesTableViewController *dealsVC = [[CategoriesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:dealsVC animated:YES];
                } else {
                    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
                    [client loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *deviceId = [defaults objectForKey:kUserNotificationToken];
                        NSArray* name = [user.name componentsSeparatedByString:@" "];
                        [User createUserWithEmail:[NSString stringWithFormat:@"%@@twitter.com", session.userName]
                                           source:@"twitter"
                                        firstName:name[0]
                                         lastName:name[1]
                                              dob:[NSDate date]
                                           gender:@0
                                         timezone:[NSTimeZone systemTimeZone]
                                         deviceId:deviceId block:^(NSDictionary * _Nonnull response) {
                                             self.twitterButton.enabled = YES;
                                             PreferencesTableViewController *prefVC = [[PreferencesTableViewController alloc] init];
                                             [self.navigationController pushViewController:prefVC animated:YES];
                                         }];
                    }];
                }
            }];
        } else {
            NSLog(@"Login error: %@", [error localizedDescription]);
        }
    }];

}

- (void)viewDidLayoutSubviews {
    self.twitterButton.frame = CGRectMake((self.view.frame.size.width - 200)/2, self.facebookButton.frame.origin.y + self.facebookButton.frame.size.height + 30, 200, self.facebookButton.frame.size.height);
    [self.view addSubview:self.twitterButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)signInButtonPressed {
    // If user has credentials saved on device
    UIViewController *nextVC;
    if (false) {
        nextVC = [[CategoriesTableViewController alloc] init];
    } else {
        nextVC = [[LoginViewController alloc] init];
    }
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark Facebook Delegate Methods
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email, first_name, last_name, birthday, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 // goto registration/login page depending on...
                 
                 [User loginWithEmail:result[@"email"] withSource:@"facebook" block:^(NSDictionary * _Nonnull response) {
                     if (!response) {
                         CategoriesTableViewController *dealsVC = [[CategoriesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                         [self.navigationController pushViewController:dealsVC animated:YES];
                     } else {
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSString *deviceId = [defaults objectForKey:kUserNotificationToken];
                         [User createUserWithEmail:result[@"email"]
                                            source:@"facebook"
                                         firstName:result[@"first_name"]
                                          lastName:result[@"last_name"]
                                               dob:result[@"birthday"]
                                            gender:result[@"gender"]
                                          timezone:[NSTimeZone systemTimeZone]
                                          deviceId:deviceId block:^(NSDictionary * _Nonnull response) {
                                              PreferencesTableViewController *prefVC = [[PreferencesTableViewController alloc] init];
                                              [self.navigationController pushViewController:prefVC animated:YES];
                         }];
                     }
                 }];
                 
                 
             } else {
                 // handle error
                 NSLog(@"error: %@", error);
             }
         }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (void)registerButtonPressed {
    RegistrationViewController *registrationVC = [[RegistrationViewController alloc] init];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
