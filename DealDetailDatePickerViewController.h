//
//  DealDetailDatePickerViewController.h
//  BumOrBorrowed
//
//  Created by Jared Friedman on 2/26/14.
//  Copyright (c) 2014 Big Red INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealDetailDatePickerViewController : UIViewController
@property (nonatomic) IBOutlet UIDatePicker *picker;
@property (nonatomic) BOOL isStartDate;
@end
