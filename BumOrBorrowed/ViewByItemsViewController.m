//
//  ViewByItemsViewController.m
//  BumOrBorrowed
//
//  Created by Jared Friedman on 2/20/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "ViewByItemsViewController.h"
#import "Parse/Parse.h"
#import "ViewDealsViewController.h"
#import "DealDetailViewController.h"
#import "ItemsCustomCell.h"


@interface ViewByItemsViewController ()<UITableViewDataSource,UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{
    PFObject *deal;
    
    __weak IBOutlet UISegmentedControl *onSegmentChangedOutlet;

}

@end

@implementation ViewByItemsViewController



- (void)viewDidLoad
{
    
    
    deal = [PFObject objectWithClassName:@"Deal"];
    
    self.parseClassName = @"Deal";
    self.paginationEnabled = YES;
    self.objectsPerPage = 7;
    
    [super viewDidLoad];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

- (IBAction)onSegmentChanged:(UISegmentedControl*)sender
{
    [self loadObjects];
}

-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if (![PFUser currentUser]) {
        return nil;
    }else{
        
        [query orderByDescending:@"item"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        
        
        //not working as we'd like. still seems random but onto the right idea.
    }
    if (onSegmentChangedOutlet.selectedSegmentIndex == 1) {
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"isdealdone" equalTo:@NO];
    }
    if (onSegmentChangedOutlet.selectedSegmentIndex == 2) {
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"isdealdone" equalTo:@YES];
    }
    return query;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dealSegue2"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        deal = [self objectAtIndexPath:indexPath];
        DealDetailViewController  *vc = segue.destinationViewController;
        vc.deal  = deal;
    }
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    ItemsCustomCell *dealCell = [tableView dequeueReusableCellWithIdentifier:@"reuseID2"];
    if (!dealCell) {
        dealCell = [[ItemsCustomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseID2"];
    }
    
    dealCell.itemTitleLabel.text = [object objectForKey:@"item"];
    //dealCell.imageView.image = [object objectForKey:@"itemimage"];
    //need to look at how to get pffile image back to image. should be done somewhere in project already
    dealCell.DetailLabel.text = [object objectForKey:@"borrower"];
    dealCell.itemImageView.file = [object objectForKey:@"itemimage"];
    [dealCell.itemImageView loadInBackground];
    
    
   
    
    NSDate *date = [object objectForKey:@"enddate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSDate *date2 = [object objectForKey:@"startdate"];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString2 = [dateFormat stringFromDate:date2];
    dealCell.startDateLabel.text = [NSString stringWithFormat:@"Start Date: %@", dateString2];
    
    if (dateString == NULL) {
        dealCell.endDateLabel.text = nil;
    }
    else{

        dealCell.endDateLabel.text = [NSString stringWithFormat:@"Return Date: %@", dateString];
    }
    
    
    if ([[object objectForKey:@"isdealdone"] boolValue] ) {
     //   NSLog(@"%@", deal);
        //deal [[dealCell.textLabel.textColor] = [UIColor redColor]];
        dealCell.itemTitleLabel.textColor = [UIColor redColor];
        dealCell.DetailLabel.textColor = [UIColor redColor];
        dealCell.accessoryType = UITableViewCellAccessoryCheckmark;
       // deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Lent %@ %@", [deal objectForKey:@"lendor"], [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
        dealCell.startDateLabel.textColor = [UIColor redColor];
        dealCell.endDateLabel.textColor = [UIColor redColor];
        
    }
    
    else{
        dealCell.itemTitleLabel.textColor = [UIColor greenColor];
        dealCell.DetailLabel.textColor = [UIColor greenColor];
        dealCell.accessoryType = UITableViewCellAccessoryNone;
        dealCell.startDateLabel.textColor = [UIColor greenColor];
        dealCell.endDateLabel.textColor = [UIColor greenColor];
    }
    
   
    
    
    
    return dealCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"test");
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}



-(IBAction)unwindFromDealDetail:(UIStoryboardSegue*)sender
{
    PFQuery *dealQuery = [PFQuery queryWithClassName:@"Deal"];
    [dealQuery whereKey:@"dealtitle" equalTo:[NSString stringWithFormat:@"%@", [deal objectForKey:@"dealtitle"]]];
    
    deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Borrowed %@", [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
    
    deal [@"isdealdone"] = @YES;
    [deal saveInBackground];
    
    //this bit saves the deal and make it say lent instead of lend, but only upon the button being pushed. If you open app and button was pushed from prior session it wont come up as lent, still lends instead. bit above under the bool doesnt do it either.
}
-(IBAction)unwindFromComposeDeal:(UIStoryboardSegue*)sender
{
    
}

@end