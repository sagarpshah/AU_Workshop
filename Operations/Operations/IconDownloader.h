//
//  IconDownloader.h
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconDownloader : NSObject
{
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    
    NSURL *url;
    NSString *imageName;
    NSString *directory;
    
    BOOL imageDownloaded;
    BOOL connectionFinished;
    UIImage *image;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL imageDownloaded;

- (id)initDownloader:(NSURL *)_url fileName:(NSString *)fileName;
- (id)initDownloader:(NSURL *)_url fileName:(NSString *)fileName searchDirectory:(NSString *)dir;

- (NSError *)startDownload;
- (void)cancel;

@end
