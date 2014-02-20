//
//  DealDetailViewController.h
//  BumOrBorrowed
//
//  Created by John Malloy on 2/11/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ViewDealsViewController.h"
#import "ViewByItemsViewController.h"

@interface DealDetailViewController : UIViewController
@property PFObject *deal;
@end
