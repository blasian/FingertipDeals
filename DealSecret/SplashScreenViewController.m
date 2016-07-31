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
#import "TermsPopUpView.h"
#import "Constants.h"

@interface SplashScreenViewController ()

@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIButton *privacyPolicyButton;
@property (nonatomic, retain) UITextView* termsPopUp;
@property (nonatomic, strong) UIView* popUpBackground;
@property (nonatomic, strong) UIButton* closeTermsButton;

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
    self.twitterButton.hidden = YES;
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

- (void) placeTermsButton {
    UIColor* grayColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(popUpPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Terms of Use" forState:UIControlStateNormal];
    [button setTitleColor:grayColor forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.frame.size.width - 150.0f)/2, self.view.frame.size.height - 150.0f, 150.0f, 40.0f);
    
    UILabel* termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, button.frame.origin.y - 50.0f, self.view.frame.size.width - 40.0f, 50.0f)];
    [termsLabel setTextAlignment:NSTextAlignmentCenter];
    [termsLabel setTextColor:grayColor];
    [termsLabel setText:@"By signing up you agree to the"];
    [self.view addSubview:termsLabel];
    [self.view addSubview:button];
}

- (void)popUpPressed {
    self.popUpBackground.hidden = !self.popUpBackground.hidden;
    self.closeTermsButton.hidden = !self.closeTermsButton.hidden;
    _termsPopUp.hidden = !_termsPopUp.hidden;
}

- (void)setTermsPopUp {
    self.popUpBackground = [[UIView alloc] initWithFrame:self.view.frame];
    self.popUpBackground.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    
    CGRect textViewFrame = CGRectMake(20.0, 30.0, self.view.frame.size.width - 40.0, self.view.frame.size.height - 150.0);
    _termsPopUp = [[UITextView alloc] initWithFrame:textViewFrame];
    _termsPopUp.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5];
    _termsPopUp.textColor = [UIColor whiteColor];
    

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popUpPressed)];
    [_termsPopUp addGestureRecognizer:gr];
    
    
    [User getTermsWithBlock:^(NSString * _Nonnull response) {
        [_termsPopUp setText:response];
    }];
    
    _closeTermsButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewFrame.origin.x, textViewFrame.origin.y + textViewFrame.size.height + 10.0f, textViewFrame.size.width, self.view.frame.size.height - (textViewFrame.origin.y + textViewFrame.size.height + 20.0f))];
    [_closeTermsButton addTarget:self action:@selector(popUpPressed) forControlEvents:UIControlEventTouchUpInside];
    [_closeTermsButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeTermsButton setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:1.0f]];
    
    [self.view addSubview:_popUpBackground];
    [self.view addSubview:_termsPopUp];
    [self.view addSubview:_closeTermsButton];
    
    self.termsPopUp.hidden = YES;
    self.closeTermsButton.hidden = YES;
    self.popUpBackground.hidden = YES;
    self.termsPopUp.editable = NO;
}

- (void)viewDidLayoutSubviews {
    [self placeTermsButton];
    [self setTermsPopUp];
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
