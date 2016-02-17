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
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.titleLabel.textColor = [UIColor whiteColor];
    self.registerButton.titleLabel.textColor = [UIColor whiteColor];
    self.facebookButton.delegate = self;
    [self.signInButton addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.twitterButton addTarget:self action:@selector(twitterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {

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

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    NSLog(@"invalidated twitter account");
}


- (void)twitterButtonPressed {
    self.twitterButton.enabled = NO;
    NSString * const TWITTER_CONSUMER_KEY = @"FeQ10vM8bAlR3csLIfW27xuNt";
    NSString * const TWITTER_CONSUMER_SECRET_KEY = @"Qu0UOqZ4MrKaqeBUtOCC6FrEnwjzMAsrkZY92NBQhnDIivg0fT";
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET_KEY];
    [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccountAndDelegate:self];
        [twitterAPIOS verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            
            [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
                
                NSLog(@"REVERSE AUTH OK");
                // user useriD as email for now
                [User loginWithEmail:[NSString stringWithFormat:@"%@@twitter.com", userID] withSource:@"twitter" block:^(NSDictionary * _Nonnull response) {
                    
                    if (!response) {
                        self.twitterButton.enabled = YES;
                        CategoriesTableViewController *dealsVC = [[CategoriesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        [self.navigationController pushViewController:dealsVC animated:YES];
                    } else {
                        [twitterAPIOS getUserInformationFor:screenName successBlock:^(NSDictionary *user) {
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSString *deviceId = [defaults objectForKey:kUserNotificationToken];
                            NSArray* name = [(NSString*)user[@"name"] componentsSeparatedByString:@" "];
                            [User createUserWithEmail:[NSString stringWithFormat:@"%@@twitter.com", userID]
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
                        } errorBlock:^(NSError *error) {
                            self.twitterButton.enabled = YES;
                            NSLog(@"ERROR");
                        }];
                    }
                }];

                
            } errorBlock:^(NSError *error) {
                self.twitterButton.enabled = YES;
                NSLog(@"ERROR, %@", [error localizedDescription]);
                
            }];
         
        } errorBlock:^(NSError *error) {
            self.twitterButton.enabled = YES;
            NSLog(@"ERROR");
            
        }];
        
    } errorBlock:^(NSError *error) {
        self.twitterButton.enabled = YES;
        NSLog(@"ERROR");
        
    }];
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
