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


@interface ViewDealsViewController () <UITableViewDataSource,UITableViewDelegate>
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




-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell *dealCell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (!dealCell) {
        dealCell = [[PFTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseID"];
    }
    dealCell.textLabel.text = [object objectForKey:@"dealtitle"];
    dealCell.detailTextLabel.text = [[object objectForKey:@"enddate"] description];

    
    if ([[object objectForKey:@"isdealdone"] boolValue] ) {
        NSLog(@"%@", deal);
        //deal [[dealCell.textLabel.textColor] = [UIColor redColor]];
        dealCell.textLabel.textColor = [UIColor redColor];
        dealCell.detailTextLabel.textColor = [UIColor redColor];

    
    }
    
    else{
        dealCell.textLabel.textColor = [UIColor greenColor];
        dealCell.detailTextLabel.textColor = [UIColor greenColor];
    }
        
        
        
        
    
    return dealCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[ segue identifier] isEqualToString:@"dealSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        deal = [self objectAtIndexPath:indexPath];
        
        
        
        //[PFQueryTableViewController.indexPath.row];     //[[self objectAtIndexPath:indexPath]];
    
        DealDetailViewController *vc = segue.destinationViewController;
        vc.deal = deal;
    }
}

-(IBAction)unwindFromDealDetail:(UIStoryboardSegue*)sender
{
    PFQuery *dealQuery = [PFQuery queryWithClassName:@"Deal"];
    [dealQuery whereKey:@"dealtitle" equalTo:[NSString stringWithFormat:@"%@", [deal objectForKey:@"dealtitle"]]];
    
    
    
    deal [@"isdealdone"] = @YES;
    [deal saveInBackground];
    
    
}


@end
