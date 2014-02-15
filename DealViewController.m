//
//  DealViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "DealViewController.h"
#import "Parse/Parse.h"

@interface DealViewController () <PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{
    __weak IBOutlet UITextField *lendorTextField;
    __weak IBOutlet UITextField *borrowerTextField;
    __weak IBOutlet UITextField *itemTextField;
    __weak IBOutlet UITextView *descriptionTextView;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    
    PFObject *deal;
}

@end

@implementation DealViewController

- (void)viewDidLoad
{
  //  [lendorTextField resignFirstResponder];
    
    deal = [PFObject objectWithClassName:@"Deal"];
    deal[@"startdate"] = [NSDate date];
    deal[@"enddate"] = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:deal[@"startdate"]];

    [super viewDidLoad];
    

}
- (IBAction)itemImagePicker:(id)sender
{
   
}

- (IBAction)onSaveButtonPressed:(id)sender
{
  
    //deal [@"dealtitle"] = dealNameTextField.text;
    deal [@"dealtitle"] =[NSString stringWithFormat: @"%@ Lends %@ %@", lendorTextField.text, borrowerTextField.text, itemTextField.text];
    
    deal [@"lendor"] = lendorTextField.text;
    deal [@"borrower"] = borrowerTextField.text;
    deal [@"item"] = itemTextField.text;
    deal [@"description"] = descriptionTextView.text;
    deal [@"isdealdone"] = @NO;

    [deal saveInBackground];
}



-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    

    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        //logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        
        [logInViewController setDelegate:self];

        
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
        return;
    
    PFLogInViewController *login = segue.destinationViewController;
    login.delegate = self;
    login.signUpController.delegate = self;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"iBorrow Login";
    [label sizeToFit];
    login.logInView.logo = label;
    label.textColor = [UIColor greenColor];
    //label.te =
    
    
    label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"iBorrow Sign Up";
    [label sizeToFit];
    login.signUpController.signUpView.logo = label;
    label.textColor = [UIColor greenColor];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onDatePickerDateChanged:(UIDatePicker *)sender {
    if (segmentedControl.selectedSegmentIndex == 0) {
        deal[@"startdate"] = datePicker.date;
        deal[@"enddate"] = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:datePicker.date];
    } else {
        deal[@"enddate"] = datePicker.date;
    }
}

- (IBAction)segmentedControlDatePicker:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        datePicker.date = [deal objectForKey:@"startdate"];
    } else {
        datePicker.date = [deal objectForKey:@"enddate"];
    }
}





@end
