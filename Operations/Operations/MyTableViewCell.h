//
//  MyTableViewCell.h
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "UITableViewCell+NIB.h"
#import "ResourceToken.h"

@interface MyTableViewCell : UITableViewCell
{
    UILabel *textLabel;
    UIImageView *imageView;
}

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) id<ResourceToken> token;

- (void)downloadImageWithURLString:(NSString *)urlString fileNameToSave:(NSString *)fileName;

@end
