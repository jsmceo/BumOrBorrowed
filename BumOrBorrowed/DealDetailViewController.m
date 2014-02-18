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
    
    __weak IBOutlet UIButton *returnItemButton;
    
    __weak IBOutlet UIImageView *itemImageView;
    

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
    
  
    
   //returnItemButton.titleLabel.text = [NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]];
    [returnItemButton setTitle:[NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]] forState:UIControlStateNormal];
    [returnItemButton setTitle:[NSString stringWithFormat:@"Return %@!", [_deal objectForKey:@"item"]] forState:UIControlStateSelected];
    returnItemButton.titleLabel.textColor = [UIColor blackColor];

    //itemImageView.image. = [UIImage imageNa]
    
    //[_deal objectForKey:@"itemimage"];
    //not sure how exactly to pull the file/data from parse to put here. cant do objectforkey here...sent file/data to parse not the image, so thats why i need file/data back here to be the image.
   
    
        }
    

    









@end
