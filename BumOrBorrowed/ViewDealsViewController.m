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
    
}

@end

@implementation ViewDealsViewController



- (void)viewDidLoad
{
    
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
        PFObject *deal = [self objectAtIndexPath:indexPath];
        
        //[PFQueryTableViewController.indexPath.row];     //[[self objectAtIndexPath:indexPath]];
    
        DealDetailViewController *vc = segue.destinationViewController;
        vc.deal = deal;
        }
}


@end
