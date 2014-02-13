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


@interface DealDetailViewController ()
{
    __weak IBOutlet UITextField *lendorDealDetailViewTextField;
    
    __weak IBOutlet UITextField *borrowerDealDetailViewTextField;
    
    __weak IBOutlet UITextField *itemDealDetailViewTextField;
    
    
    __weak IBOutlet UITextField *createdDateDealDetailViewTextField;
    
    __weak IBOutlet UITextField *endDateDealDetailViewTextField;
    
    __weak IBOutlet UITextView *descriptionDealDetailViewTextView;
    
    
    __weak IBOutlet UINavigationItem *navBarDealTitle;
    
    __weak IBOutlet UILabel *bottomrReturnItemTextlabel;
}

@end

@implementation DealDetailViewController



- (void)viewDidLoad
{
    
 
    [super viewDidLoad];


    lendorDealDetailViewTextField.text = [_deal objectForKey:@"lendor"];
    borrowerDealDetailViewTextField.text = [_deal objectForKey:@"borrower"];
    itemDealDetailViewTextField.text = [_deal objectForKey:@"item"];
    
    createdDateDealDetailViewTextField.text = [[_deal objectForKey:@"startdate"] description];
    
    endDateDealDetailViewTextField.text = [[_deal objectForKey:@"enddate"] description];
                                           
    descriptionDealDetailViewTextView.text = [_deal objectForKey:@"description"];
    
    navBarDealTitle.title = [_deal objectForKey:@"dealtitle"];
    
    bottomrReturnItemTextlabel.text= [NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]];
    
    
//    bottomReturnItemButton.font = [NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]];
}







@end
