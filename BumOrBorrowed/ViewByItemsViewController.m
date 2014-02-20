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


@interface ViewByItemsViewController ()<UITableViewDataSource,UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{
    PFObject *deal;
    
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
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if (![PFUser currentUser]) {
        return nil;
    }else{
        
        [query orderByAscending:@"enddate"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        
        return query;
        //not working as we'd like. still seems random but onto the right idea.
    }
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
    PFTableViewCell *dealCell = [tableView dequeueReusableCellWithIdentifier:@"reuseID2"];
    if (!dealCell) {
        dealCell = [[PFTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseID2"];
    }
    
    dealCell.textLabel.text = [object objectForKey:@"item"];
    //dealCell.imageView.image = [object objectForKey:@"itemimage"];
    //need to look at how to get pffile image back to image. should be done somewhere in project already
    
    NSDate *date = [object objectForKey:@"enddate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSDate *date2 = [object objectForKey:@"startdate"];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString2 = [dateFormat stringFromDate:date2];
    
    if (dateString == NULL) {
        dealCell.detailTextLabel.text = [NSString stringWithFormat:@"Borrower: %@ Start Date: %@", [object objectForKey:@"borrower"],  dateString2];
    }else{
        
        
        dealCell.detailTextLabel.text = [NSString stringWithFormat:@"Borrower: %@ Start Date: %@ - End Date %@", [object objectForKey:@"borrower"], dateString2, dateString];
        
    }
    if ([[object objectForKey:@"isdealdone"] boolValue] ) {
     //   NSLog(@"%@", deal);
        //deal [[dealCell.textLabel.textColor] = [UIColor redColor]];
        dealCell.textLabel.textColor = [UIColor redColor];
        dealCell.detailTextLabel.textColor = [UIColor redColor];
        dealCell.accessoryType = UITableViewCellAccessoryCheckmark;
       // deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Lent %@ %@", [deal objectForKey:@"lendor"], [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
        
        
    }
    
    else{
        dealCell.textLabel.textColor = [UIColor greenColor];
        dealCell.detailTextLabel.textColor = [UIColor greenColor];
        dealCell.accessoryType = UITableViewCellAccessoryNone;
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
    
    deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Lent %@ %@", [deal objectForKey:@"lendor"], [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
    
    deal [@"isdealdone"] = @YES;
    [deal saveInBackground];
    
    //this bit saves the deal and make it say lent instead of lend, but only upon the button being pushed. If you open app and button was pushed from prior session it wont come up as lent, still lends instead. bit above under the bool doesnt do it either.
}
//-(IBAction)unwindFromComposeDeal:(UIStoryboardSegue*)sender
//{
//    
//}

@end