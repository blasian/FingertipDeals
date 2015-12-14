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

@interface SplashScreenViewController ()

@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.
    self.signInButton.titleLabel.textColor = [UIColor whiteColor];
    self.registerButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self.signInButton addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
