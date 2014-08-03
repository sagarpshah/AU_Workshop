//
//  ViewController.h
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *imagesArray;
}

@property (nonatomic, strong) IBOutlet UITableView *imagesTableView;

@end