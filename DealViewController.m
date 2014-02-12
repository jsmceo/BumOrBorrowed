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
    __weak IBOutlet UITextField *dealNameTextField;
  //  __weak IBOutlet UIDatePicker *dealStartDatePicker;
    
}

@end

@implementation DealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)onSaveButtonPressed:(id)sender
{
    PFObject *deal = [PFObject objectWithClassName:@"Deal"];
    deal [@"dealtitle"] = dealNameTextField.text;
    deal [@"lendor"] = lendorTextField.text;
    deal [@"borrower"] = borrowerTextField.text;
    deal [@"item"] = itemTextField.text;
    deal [@"description"] = descriptionTextView.text;
   // deal [@]

    [deal saveInBackground];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
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
    
    
    label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"iBorrow Sign Up";
    [label sizeToFit];
    login.signUpController.signUpView.logo = label;
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
