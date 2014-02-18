//
//  ViewDealsViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "ViewDealsViewController.h"
#import "Parse/Parse.h"
#import "DealDetailViewController.h"


@interface ViewDealsViewController () <UITableViewDataSource,UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{
    PFObject *deal;

}

@end

@implementation ViewDealsViewController



- (void)viewDidLoad
{
    
    
    deal = [PFObject objectWithClassName:@"Deal"];

    self.parseClassName = @"Deal";
 
    [super viewDidLoad];
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        //logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        
        [logInViewController setDelegate:self];

        [logInViewController
         
         setFacebookPermissions:@[@"user_about_me",@"user_birthday",@"user_relationships",@"email",@"read_insights",@"create_event",@"manage_notifications",@"user_location",@"publish_actions"]];
        
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

//-(PFQuery *)queryForTable
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"Deal"];
//    
//    [query orderByDescending:@"returndate"];
//    
//    return query;
//    //not working as we'd like. still seems random but onto the right idea.
//}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dealSegue"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        deal = [self objectAtIndexPath:indexPath];
        
        DealDetailViewController *vc = segue.destinationViewController;
        vc.deal = deal;
    }
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell *dealCell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (!dealCell) {
        dealCell = [[PFTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseID"];
    }
    dealCell.textLabel.text = [object objectForKey:@"dealtitle"];
    dealCell.detailTextLabel.text = [[object objectForKey:@"enddate"] description];
  //  dealCell.detailTextLabel.text = [[[object objectForKey:@"enddate"] dateStyle = NSDateFormatterMediumStyle] ];
    

    
    if ([[object objectForKey:@"isdealdone"] boolValue] ) {
        NSLog(@"%@", deal);
        //deal [[dealCell.textLabel.textColor] = [UIColor redColor]];
        dealCell.textLabel.textColor = [UIColor redColor];
        dealCell.detailTextLabel.textColor = [UIColor redColor];
        dealCell.accessoryType = UITableViewCellAccessoryCheckmark;

    
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
}



-(IBAction)unwindFromDealDetail:(UIStoryboardSegue*)sender
{
    PFQuery *dealQuery = [PFQuery queryWithClassName:@"Deal"];
    [dealQuery whereKey:@"dealtitle" equalTo:[NSString stringWithFormat:@"%@", [deal objectForKey:@"dealtitle"]]];
    
    
    deal [@"isdealdone"] = @YES;
    [deal saveInBackground];
    

}
-(IBAction)unwindFromComposeDeal:(UIStoryboardSegue*)sender
{
}



@end

