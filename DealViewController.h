//
//  DealViewController.h
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>


@interface DealViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, FBFriendPickerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *BorrowerTextFieldProperty;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFieldProperty;

@property(strong, nonatomic)UIImagePickerController *imagePicker;




@end
