//
//  RegistrationViewController.m
//  DealSecret
//
//  Created by Michael Spearman on 12/9/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"
#import "CategoriesTableViewController.h"
#import "TextField.h"
#import "PreferencesTableViewController.h"

@interface RegistrationViewController ()

@property (nonatomic, strong) IBOutletCollection(TextField) NSArray* textfields;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet TextField* emailField;
@property (nonatomic, weak) IBOutlet TextField* passwordField;
@property (nonatomic, weak) IBOutlet TextField* confirmPasswordField;
@property (nonatomic, weak) IBOutlet TextField* firstNameField;
@property (nonatomic, weak) IBOutlet TextField* lastNameField;
@property (nonatomic, weak) IBOutlet TextField* dobField;
@property (nonatomic, weak) IBOutlet UISegmentedControl* genderControl;
@property (nonatomic, weak) IBOutlet UIButton* nextButton;

@property (nonatomic, strong) UITextField* activeField;
@property (nonatomic, strong) NSDate* dob;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Register";
    self.navigationController.navigationBarHidden = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [datePicker addTarget:self action:@selector(dobSelected:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.dobField.inputView = datePicker;
    self.dobField.tintColor = [UIColor clearColor];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)]];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.dob = [NSDate date];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dobSelected:(id)sender {
    UIDatePicker *picker = sender;
    self.dob = picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    self.dobField.text = [formatter stringFromDate:picker.date];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void)backgroundTapped {
    [self.view endEditing:YES];
}

- (void)nextButtonPressed {
    
    // 0 = Male
    // 1 = Female
    NSInteger gender = self.genderControl.selectedSegmentIndex;
    
    /*
    NSDictionary* params = @{@"email" : self.emailField.text,
                             @"password" : self.passwordField.text,
                             @"firstname" :self.firstNameField.text,
                             @"lastname" : self.lastNameField.text,
                             @"dob" : self.dobField.text,
                             @"gender" : [NSNumber numberWithInteger:gender]};
    NSLog(@"%@", params);
    */
    
    [User createUserWithEmail:self.emailField.text
                     password:self.passwordField.text
                    firstName:self.firstNameField.text
                     lastName:self.lastNameField.text
                          dob:self.dob
                       gender:[NSNumber numberWithInteger:gender]
                        block:^void(NSDictionary* response) {
        NSLog(@"%@", response);
        if ([response valueForKey:@"error"] == nil) {
            PreferencesTableViewController *prefVC = [[PreferencesTableViewController alloc] init];
            [self.navigationController pushViewController:prefVC animated:YES];
        } else {
            NSLog(@"error registering account");
            // Display error message to user.
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
