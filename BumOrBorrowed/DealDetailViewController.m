//
//  DealDetailViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "DealDetailViewController.h"
#import "Parse/Parse.h"
#import "ViewDealsViewController.h"
#import "ViewByItemsViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface DealDetailViewController ()
{
    
    __weak IBOutlet UITextField *borrowerDealDetailViewTextField;
    
    __weak IBOutlet UITextField *itemDealDetailViewTextField;
    
    
    __weak IBOutlet UITextField *createdDateDealDetailViewTextField;
    
    __weak IBOutlet UITextField *endDateDealDetailViewTextField;
    
    __weak IBOutlet UITextView *descriptionDealDetailViewTextView;
    
    
    __weak IBOutlet UINavigationItem *navBarDealTitle;
    
    __weak IBOutlet UIButton *returnItemButton;
    
    __weak IBOutlet PFImageView *itemImageView;
    __weak IBOutlet UITextField *borrowerNumberField;
    __weak IBOutlet UILabel *phoneNumberLabel;
    
    UIImage *itemImage;
    PFObject *object;
    NSString *FBID;
    UIImage *capturedScreen;
}

@end

@implementation DealDetailViewController




- (void)viewDidLoad
{
    
 
    [super viewDidLoad];


    borrowerDealDetailViewTextField.text = [_deal objectForKey:@"borrower"];
    itemDealDetailViewTextField.text = [_deal objectForKey:@"item"];
    
    NSDate *date = [_deal objectForKey:@"startdate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
   // NSLog(@"Date: %@", dateString);
    createdDateDealDetailViewTextField.text = dateString;
    
    NSDate *date1 = [_deal objectForKey:@"enddate"];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString1 = [dateFormat1 stringFromDate:date1];
    //NSLog(@"Date: %@", dateString1);
    endDateDealDetailViewTextField.text = dateString1;
    
                                           
    descriptionDealDetailViewTextView.text = [_deal objectForKey:@"description"];
    
    navBarDealTitle.title = [_deal objectForKey:@"dealtitle"];
    
  
    
   //returnItemButton.titleLabel.text = [NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]];
    [returnItemButton setTitle:[NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]] forState:UIControlStateNormal];
    [returnItemButton setTitle:[NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]] forState:UIControlStateSelected];
    returnItemButton.titleLabel.textColor = [UIColor blackColor];
    
    borrowerNumberField.text = [_deal objectForKey:@"borrowernumber"];
    
    
    
    
    
    itemImageView.file = [_deal objectForKey:@"itemimage"];
    [itemImageView loadInBackground];
    
    FBID = [_deal objectForKey:@"FBID"];
    //just a way to have the facebook id there if we need it, to be able to message or post to the other user. if theyre a fbuser of course...maybe we can do if statement to only even bring this up IF they are in face fbusers.
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (![[_deal objectForKey:@"borrowernumber" ] isEqual: @""]) {
        borrowerNumberField.backgroundColor = [UIColor whiteColor];
    }else{
       // borrowerNumberField.alpha = 0;
       // phoneNumberLabel.alpha = 0;
        
        //idea here was for that phone number field to not appear(or at least be same color as background and seem to not appear) if no number is coming in. cant quite seem to get it properly, surely there is a better way anyways.
    }
}
- (IBAction)onSaveSendPressed:(id)sender
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self sendMessage];
}
-(void)sendMessage
{
    NSString *recipientPhoneNumber = borrowerNumberField.text;

    if ([MFMessageComposeViewController canSendText])
    {
        
        MFMessageComposeViewController *mvc = [MFMessageComposeViewController new];
        mvc.recipients = @[recipientPhoneNumber];
        if (endDateDealDetailViewTextField == nil) {
            mvc.body =@"I have lent you something with BorrowHero... You're welcome! Review your borrow terms in this image.";
        }else{
        mvc.body = [NSString stringWithFormat:@"I have lent you something... You're welcome! Review your borrow terms in this image. %@", endDateDealDetailViewTextField.text];
        }
        mvc.messageComposeDelegate = self;
    
        if ([MFMessageComposeViewController canSendAttachments])
        {
            NSData *data = UIImagePNGRepresentation(capturedScreen);
            [mvc addAttachmentData:data typeIdentifier:@"public.data" filename:@"image.png"];
        }
        
        [self presentViewController:mvc animated:YES completion:nil];
    }
}


- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates
{
    return NO;
}




@end
