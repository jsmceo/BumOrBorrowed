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


@interface ViewByItemsViewController ()<UITableViewDataSource,UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, UISearchBarDelegate>
{
    PFObject *deal;
    
    IBOutlet UISegmentedControl *onSegmentChangedOutlet;
    
   __weak IBOutlet UISearchBar *searchBar;
    NSDate *now;

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


    self.navigationItem.title = @"BORROW HERO";
    self.navigationItem.titleView = nil;

////// max changes
    self.navigationItem.leftBarButtonItem = nil;

    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bg.backgroundColor = [UIColor blackColor];
    [bg addSubview:onSegmentChangedOutlet];
    [onSegmentChangedOutlet sizeToFit];
    onSegmentChangedOutlet.center = CGPointMake(160, 22);
    [self.view addSubview:bg];


    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Black" size:24],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.357 green:0.745 blue:0.667 alpha:1]
    };

    [[UIFont familyNames] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@", [UIFont fontNamesForFamilyName:obj]);
    }];
}

- (void)viewDidLayoutSubviews {
    onSegmentChangedOutlet.superview.frame = (CGRect){self.tableView.contentOffset, 320, 44};
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        //logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        
        [logInViewController setDelegate:self];
        
        [logInViewController setFacebookPermissions:@[@"user_about_me",@"user_birthday",@"user_relationships",@"email",@"read_insights",@"create_event",@"manage_notifications",@"user_location",@"publish_actions"]];
        
        logInViewController.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsLogInButton
        | PFLogInFieldsSignUpButton
        | PFLogInFieldsPasswordForgotten
        | PFLogInFieldsDismissButton
        | PFLogInFieldsFacebook;
        
        
        
        //        if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        //            [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error)
        //             }
        //
        //
        //             }
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"BorrowHero Login";
        [label sizeToFit];
        logInViewController.logInView.logo = label;
        label.textColor = [UIColor greenColor];
        label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"BorrowHero Sign Up";
        [label sizeToFit];
        logInViewController.signUpController.signUpView.logo = label;
        label.textColor = [UIColor greenColor];
        
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    [self loadObjects];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}




- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadObjects];
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
    
    if (searchBar.text.length) {
        [query whereKey:@"item" matchesRegex:searchBar.text modifiers:@"i"];
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
    dealCell.itemImageView.image = nil;
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
                                 
    dealCell.DetailLabel.text = [NSString stringWithFormat:@"Lent to %@ on %@", [object objectForKey:@"borrower"], dateString2];
    
    if (dateString == NULL) {
        dealCell.endDateLabel.text = nil;
    }
    if (!(dateString == NULL)) {
        dealCell.endDateLabel.text = [NSString stringWithFormat:@"Returning on %@", dateString];
    }
    date = [NSDate date];

    if (date.timeIntervalSince1970 > [[object objectForKey:@"enddate"] timeIntervalSince1970] && object[@"enddate"]) {
        dealCell.endDateLabel.text = @"Late";
    }

    
    if ([[object objectForKey:@"isdealdone"] boolValue] ) {
     //   NSLog(@"%@", deal);
        //deal [[dealCell.textLabel.textColor] = [UIColor redColor]];
       
       
       // deal [@"dealtitle"] = [NSString stringWithFormat: @"%@ Lent %@ %@", [deal objectForKey:@"lendor"], [deal objectForKey:@"borrower"], [deal objectForKey:@"item"]];
        dealCell.endDateLabel.textColor = [UIColor greenColor];
        dealCell.endDateLabel.text = @"Returned";

    }
    
    else{
       
       
        
        dealCell.endDateLabel.textColor = [UIColor redColor];
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