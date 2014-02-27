//
//  ItemsCustomCell.m
//  BumOrBorrowed
//
//  Created by Jared Friedman on 2/25/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import "ItemsCustomCell.h"

@implementation ItemsCustomCell {
    UINavigationBar *blur;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!blur) {
        blur = [[UINavigationBar alloc] initWithFrame:CGRectMake(8, 8, 304, 63)];
        blur.barStyle = UIBarStyleDefault;

        self.itemTitleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16];
        self.DetailLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
        self.endDateLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    }

    [self.contentView insertSubview:blur aboveSubview:self.itemImageView];
    blur.frame = CGRectMake(8, 103, 304, 63);
}

@end
