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
#import "DealDetailDatePickerViewController.h"


@interface DealViewController () <UIImagePickerControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    __weak IBOutlet UITextField *borrowerTextField;
    __weak IBOutlet UITextField *itemTextField;
    __weak IBOutlet UIButton *onStartButtonPressed;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    __weak IBOutlet UITextField *borrowerNumberField;
    __weak IBOutlet UILabel *startDateLabel;
    __weak IBOutlet UILabel *endDateLabel;
    __weak IBOutlet UIToolbar *toolbar;
    __weak IBOutlet UIButton *lendOutButton;
    __weak IBOutlet UINavigationItem *enterNavTitle;
    
    __weak IBOutlet UIButton *cameraButtonOutlet;
    __weak IBOutlet UITextField *descriptionTextField;
    PFObject *deal;
    
    UIImage *itemImage;
    __weak IBOutlet UIImageView *myItemImageView;
    PFObject *imageData;
    PFObject *activityIndicator;
    PFObject *userPhoneNumber;
    
    FBFriendPickerViewController *facebookPickerController;
    NSString *FBID;
    
    id note1, note2;
}
@end



@implementation DealViewController

- (void)viewDidLoad
{
    
    lendOutButton.layer.cornerRadius = 5;
  
    
    self.BorrowerTextFieldProperty.delegate = self;
    self.itemTextFieldProperty.delegate = self;
    self.descriptionTextFieldProperty.delegate = self;
    
    deal = [PFObject objectWithClassName:@"Deal"];
    deal[@"startdate"] = [NSDate date];
    [super viewDidLoad];
    
    
    note1 = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
    {
        [UIView animateWithDuration:0.4 animations:^{
            toolbar.transform = CGAffineTransformMakeTranslation(0, -430);
        }];
    }];
    note2 = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         [UIView animateWithDuration:0.4 animations:^{
             toolbar.transform = CGAffineTransformIdentity;
         }];
     }];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)];
    [self.view addGestureRecognizer:gr];
     //enterNavTitle.titleView.
}

- (void)ontap {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:note1];
    [[NSNotificationCenter defaultCenter] removeObserver:note2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [borrowerTextField resignFirstResponder];
    [itemTextField resignFirstResponder];
    [descriptionTextField resignFirstResponder];
    return NO;
}




-(void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    itemImage= [info valueForKey:UIImagePickerControllerOriginalImage];
    myItemImageView.image = itemImage;
    
    cameraButtonOutlet.enabled = NO;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)onSaveButtonPressed:(id)sender
{
  
    //deal [@"dealtitle"] = dealNameTextField.text;
    deal [@"dealtitle"] =[NSString stringWithFormat: @"%@ Borrowed %@", borrowerTextField.text, itemTextField.text];
    
    deal [@"borrower"] = borrowerTextField.text;
    deal [@"item"] = itemTextField.text;
    deal [@"description"] = descriptionTextField.text;
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
    //borrowerTextField.font = [UIFont. ]
    
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




//
//- (IBAction)onDatePickerDateChanged:(UIDatePicker *)sender {
//    if (segmentedControl.selectedSegmentIndex == 0)
//    {
//        deal[@"startdate"] = datePicker.date;
//    }
//    else if (segmentedControl.selectedSegmentIndex == 1)
//    {
//        deal[@"enddate"] = datePicker.date;
//    }
//}

//- (IBAction)segmentedControlDatePicker:(UISegmentedControl *)sender
//{
//    if (sender.selectedSegmentIndex == 0) {
//        datePicker.date = [deal objectForKey:@"startdate"];
//    }
//    else if (segmentedControl.selectedSegmentIndex == 1) {
//        if (!deal[@"enddate"]) {
//            deal[@"enddate"] = [NSDate dateWithTimeInterval:7*24*60*60 sinceDate:datePicker.date];
//        }
//        datePicker.date = deal[@"enddate"];
//    }
//}

//-(IBAction)unwindFromDealDetail:(UIStoryboardSegue*)sender
//{
//    PFQuery *dealQuery = [PFQuery queryWithClassName:@"Deal"];
//    [dealQuery whereKey:@"dealtitle" equalTo:[NSString stringWithFormat:@"%@", [deal objectForKey:@"dealtitle"]]];
//    
//    deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Borrowed %@", [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
//    
//    deal [@"isdealdone"] = @YES;
//    [deal saveInBackground];
//    
//   
//}
- (IBAction)onNewDatePickerChanged:(UIDatePicker*)sender
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    DealDetailDatePickerViewController *picker = segue.destinationViewController;
    if ([picker isKindOfClass:[DealDetailDatePickerViewController class]])
        picker.isStartDate = sender == onStartButtonPressed;
}


-(IBAction)unwindFromDatePickerView:(UIStoryboardSegue*)sender
{
    
    DealDetailDatePickerViewController *vc = sender.sourceViewController;
    NSDate *date = vc.picker.date;
    
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc]init];
    [startDateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateText = [startDateFormatter stringFromDate:date];
    
    if (vc.isStartDate) {
        startDateLabel.text = dateText;
        deal[@"startdate"] = date;
    } else {
        endDateLabel.text = dateText;
        deal[@"enddate"] = date;
    }
}



@end
