//
//  SDAddDateViewController.h
//  SyncDemo
//
//  Created by Ishi Systems on 25/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDAddDateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *option1TextField;
@property (strong, nonatomic) IBOutlet UITextField *option2TextField;
@property (strong, nonatomic) IBOutlet UIButton *setDateButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *entityName;

@property (copy, nonatomic) void (^addDateCompletionBlock)(void);

- (IBAction)setDateButtonTouched:(id)sender;
- (IBAction)saveButtonTouched:(id)sender;

@end
