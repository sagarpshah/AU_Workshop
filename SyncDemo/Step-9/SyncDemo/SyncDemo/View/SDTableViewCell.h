//
//  SDTableViewCell.h
//  SyncDemo
//
//  Created by Ishi Systems on 25/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end
