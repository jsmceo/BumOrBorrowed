//
//  ViewDealsViewController.m
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "ViewDealsViewController.h"
#import "Parse/Parse.h"


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
    dealCell.detailTextLabel.text = object.createdAt.description;
    
    return dealCell;
}




@end
