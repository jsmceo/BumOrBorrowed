//
//  DealViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "DealViewController.h"
#import "Parse/Parse.h"

@interface DealViewController ()
{
    __weak IBOutlet UITextField *lendorTextField;
    __weak IBOutlet UITextField *borrowerTextField;
    __weak IBOutlet UITextField *itemTextField;
    __weak IBOutlet UITextView *descriptionTextView;
    __weak IBOutlet UITextField *dealNameTextField;
    
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
    PFObject * deal = [PFObject objectWithClassName:@"Deal"];
    deal [@"dealtitle"] = dealNameTextField.text;
    deal [@"lendor"] = lendorTextField.text;
    deal [@"borrower"] = borrowerTextField.text;
    deal [@"item"] = itemTextField.text;
    deal [@"description"] = descriptionTextView.text;

    [deal saveInBackground];
}


@end
