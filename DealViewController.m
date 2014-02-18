//
//  DealViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "DealViewController.h"
#import "Parse/Parse.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBookUI/AddressBookUI.h>



@interface DealViewController () <UIImagePickerControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    __weak IBOutlet UITextField *lendorTextField;
    __weak IBOutlet UITextField *borrowerTextField;
    __weak IBOutlet UITextField *itemTextField;
    __weak IBOutlet UITextView *descriptionTextView;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    
    PFObject *deal;
    
    UIImage *itemImage;
    __weak IBOutlet UIImageView *myItemImageView;
    PFObject *imageData;
    PFObject *activityIndicator;
}


@end

@implementation DealViewController

- (void)viewDidLoad
{
    
    deal = [PFObject objectWithClassName:@"Deal"];
    deal[@"startdate"] = [NSDate date];
    deal[@"enddate"] = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:deal[@"startdate"]];

    [super viewDidLoad];
    
 
}



-(void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    itemImage= [info valueForKey:UIImagePickerControllerOriginalImage];
    myItemImageView.image = itemImage;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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
    
    
    
    
    
     NSData *data = UIImageJPEGRepresentation(itemImage, 0.9);
    
    if (data.length) {
        deal [@"itemimage"] = [PFFile fileWithData:data];
    }


    [deal saveInBackground];

    
        //[self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }
- (IBAction)contactsButton:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];

}
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    self.BorrowerTextFieldProperty.text = [NSString stringWithFormat:@"%@ %@", name, lastName];
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        
    } else {
        phone = @"[None]";
    }
  
   // self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}





//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    
//    PFLogInViewController *login = segue.destinationViewController;
//    login.delegate = self;
//    login.signUpController.delegate = self;
//    
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//    label.text = @"iBorrow Login";
//    [label sizeToFit];
//    login.logInView.logo = label;
//    label.textColor = [UIColor greenColor];
//    //label.te =
//    
//    
//
//}


 - (void)logoutButtonTouchHandler:(id)sender  {
     [PFUser logOut]; // Log out
     
     // Return to login page
     [self.navigationController popToRootViewControllerAnimated:YES];
 }

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
	
}


- (IBAction)chooseItemImagePressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
      [self presentViewController:imagePicker animated:YES completion:NULL];
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
