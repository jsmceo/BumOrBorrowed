//
//  ItemsCustomCell.h
//  BumOrBorrowed
//
//  Created by Jared Friedman on 2/25/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import <Parse/Parse.h>

@interface ItemsCustomCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *DetailLabel;
@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end
