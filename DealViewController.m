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
    __weak IBOutlet UITextField *borrowerNumberField;
    
    PFObject *deal;
    
    UIImage *itemImage;
    __weak IBOutlet UIImageView *myItemImageView;
    PFObject *imageData;
    PFObject *activityIndicator;
    PFObject *userPhoneNumber;
    
    FBFriendPickerViewController *facebookPickerController;
    NSString *FBID;
}
@end



@implementation DealViewController

- (void)viewDidLoad
{
    
    deal = [PFObject objectWithClassName:@"Deal"];
    deal[@"startdate"] = [NSDate date];

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
    deal [@"borrowernumber"] = borrowerNumberField.text;
    deal [@"user"] = [PFUser currentUser];
    //need if statement here for if the borrower is NOT a facebook user. cant save nil FBID it breaks
    //need to check if saving fbid as empty string is right way... might just want to learn how to leave it empty
    if ( FBID == nil) {
        deal [@"FBID"] = @"";
    }else{
    deal [@"FBID"] = FBID;
    }
    
    NSData *data = UIImageJPEGRepresentation(itemImage, 0.9);
    
    if (data.length) {
        deal [@"itemimage"] = [PFFile fileWithData:data];
    }

    [deal saveInBackground];

    
    //[self performSegueWithIdentifier:@"SignInSegue" sender:self];
}

- (IBAction)onContactButtonPressed:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];

    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
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
    self.phoneNumberFieldProperty.text = phone;
    CFRelease(phoneNumbers);
}

- (IBAction)facebookPickerButton:(id)sender
{
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self facebookPickerButton:(id)sender];
                                          }
                                      }];
        return;
    }
    
    if (facebookPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        facebookPickerController = [[FBFriendPickerViewController alloc] init];
        facebookPickerController.title = @"Pick Friends";
        facebookPickerController.delegate = self;
        NSSet *fields = [NSSet setWithObjects:@"installed", nil];
        facebookPickerController.fieldsForRequest = fields;
    }
    
    [facebookPickerController loadData];
    [facebookPickerController clearSelection];
    
    [self presentViewController:facebookPickerController animated:YES completion:nil];







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

}

-(void)facebookViewControllerDoneWasPressed:(id)sender
{
    facebookPickerController.selection;
    NSLog(@"friend = %@", facebookPickerController.selection);
    
    NSString *name;
      for( id<FBGraphUser> object in facebookPickerController.selection)
{
    name = object[@"name"];
    
}
    
    
    for (id<FBGraphUser> object in facebookPickerController.selection)
    {
        FBID = object[@"id"];
    }
    
    borrowerTextField.text = name;

    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    
      [self presentViewController:imagePicker animated:YES completion:NULL];
}





- (IBAction)onDatePickerDateChanged:(UIDatePicker *)sender {
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        deal[@"startdate"] = datePicker.date;
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        deal[@"enddate"] = datePicker.date;
    }
}

- (IBAction)segmentedControlDatePicker:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        datePicker.date = [deal objectForKey:@"startdate"];
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        if (!deal[@"enddate"]) {
            deal[@"enddate"] = [NSDate dateWithTimeInterval:7*24*60*60 sinceDate:datePicker.date];
        }
        datePicker.date = deal[@"enddate"];
    }
}





@end
