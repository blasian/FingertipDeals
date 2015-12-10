//
//  RegistrationViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/9/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"
#import "DealsTableViewController.h"

@interface RegistrationViewController ()

@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;
@property (nonatomic, weak) IBOutlet UITextField* confirmPasswordField;
@property (nonatomic, weak) IBOutlet UITextField* firstNameField;
@property (nonatomic, weak) IBOutlet UITextField* lastNameField;
@property (nonatomic, weak) IBOutlet UITextField* dobField;
@property (nonatomic, weak) IBOutlet UISegmentedControl* genderControl;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitRegistrationForm:(id)sender {
    
//    NSDictionary* params = @{@"email" : self.emailField.text,
//                             @"password" : self.passwordField.text,
//                             @"firstname" :self.firstNameField.text,
//                             @"lastname" : self.lastNameField.text,
//                             @"dob" : self.dobField.text,
//                             @"gender" :self.genderField.text};
//    NSLog(@"%@", params);
    
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
