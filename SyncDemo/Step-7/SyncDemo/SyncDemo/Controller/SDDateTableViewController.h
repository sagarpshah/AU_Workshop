//
//  SDDateTableViewController.h
//  SyncDemo
//
//  Created by Ishi Systems on 25/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDateTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshButtonTouched:(id)sender;

@end
