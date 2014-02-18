//
//  DealViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "DealViewController.h"
#import "Parse/Parse.h"

@interface DealViewController () <UIImagePickerControllerDelegate>
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
    
    deal [@"itemimage"] = [PFFile fileWithData:data];
    
    

    [deal saveInBackground];
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
