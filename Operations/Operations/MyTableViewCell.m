//
//  MyTableViewCell.m
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "MyTableViewCell.h"
#import "IconDownloader.h"
#import "ResourceLoader.h"

@implementation MyTableViewCell

@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

- (void)downloadImageWithURLString:(NSString *)urlString fileNameToSave:(NSString *)fileName
{
    if (self.token) {
        [self.token cancel];
        self.token = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    IconDownloader *downloader = [[IconDownloader alloc] initDownloader:url fileName:fileName];
    
    self.imageView.image = [UIImage imageNamed:@"Image"];
    
    ResourceLoader *loader = [ResourceLoader sharedResourceLoader];
    self.token = [loader threadOnObject:downloader forDelegate:self withSelector:@selector(startDownload)];
}

- (void)loadingResourceDidFinish:(IconDownloader *)downloader
{
    if (downloader.imageDownloaded)
        self.imageView.image = downloader.image;
    
    self.token = nil;
}

- (void)loadingResourceDidFinishWithError:(NSError *)error forResource:(IconDownloader *)downloader
{
    if (downloader.imageDownloaded)
        self.imageView.image = downloader.image;
    
    self.token = nil;
}

- (void)dealloc
{
    if (self.token) {
        [self.token cancel];
        self.token = nil;
    }
    
    self.textLabel = nil;
    self.imageView = nil;
    self.token = nil;
}

@end
