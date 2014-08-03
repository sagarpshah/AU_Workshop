//
//  IconDownloader.m
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "IconDownloader.h"
#import "NSString+Extensions.h"

@implementation IconDownloader

@synthesize url;
@synthesize image;
@synthesize imageDownloaded;

#pragma mark

- (void)dealloc
{
    self.url = nil;
	self.image = nil;
}


- (id)initDownloader:(NSURL *)_url fileName:(NSString *)fileName searchDirectory:(NSString *)dir {
	if (self = [super init]) {
		self.url = _url;
		imageName = [[NSString alloc] initWithString:fileName];
		if (dir)
			directory = [[NSString alloc] initWithString:dir];
		
		imageDownloaded = NO;
		
		NSString *imagePath;
		if (!dir)
			imagePath = [imageName pathInPrivateDirectory];
		else
			imagePath = [imageName pathInDirectory:dir];
		
		NSFileManager *manager = [NSFileManager defaultManager];
		if ([manager fileExistsAtPath:imagePath]) {
			imageDownloaded = YES;
			self.image = [UIImage imageWithContentsOfFile:imagePath];
		}
	}
	
	return self;
}


- (id)initDownloader:(NSURL *)_url fileName:(NSString *)fileName {
    /*	if (self = [super init]) {
     url = [_url retain];
     imageName = [fileName retain];
     
     imageDownloaded = NO;
     
     NSString *imagePath = [imageName pathInDocumentDirectory];
     NSFileManager *manager = [NSFileManager defaultManager];
     if ([manager fileExistsAtPath:imagePath]) {
     imageDownloaded = YES;
     self.image = [UIImage imageWithContentsOfFile:imagePath];
     }
     }
     
     return self; */
	
	
	return [self initDownloader:_url fileName:fileName searchDirectory:nil];
}


- (NSError *)startDownload {
	
	connectionFinished = NO;
	
	activeDownload = [[NSMutableData alloc] init];
    imageConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
	
	while(!connectionFinished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                                          beforeDate:[NSDate distantFuture]]);
	
	[imageConnection cancel];
	
	return nil;
}


- (void)resizeImage {
	CGSize itemSize = CGSizeMake(130.0, 130.0);
	UIGraphicsBeginImageContext(itemSize);
	CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
	[image drawInRect:imageRect];
	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSString *thumbnailDirectory = @"";
	if (!directory)
		thumbnailDirectory = @"Thumbnail/";
	else
		thumbnailDirectory = [directory stringByAppendingString:@"Thumbnail/"];
    
	NSString *imagePath = [imageName pathInDirectory:thumbnailDirectory];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:imagePath])
		[UIImageJPEGRepresentation(resizedImage, 1.0) writeToFile:imagePath atomically:YES];
}

/**
 * Shuts down the connection and displays the result (statusString == nil)
 * or the error status (otherwise).
 */
- (void)_stopReceiveWithStatus:(NSString *)statusString code:(int)statusCode {
    [imageConnection cancel];
	
	connectionFinished = YES;
	imageDownloaded = NO;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse;
	NSString *contentTypeHeader;
	
	assert(conection == imageConnection);
	httpResponse = (NSHTTPURLResponse *)response;
	
	assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
	
	if ((httpResponse.statusCode / 100) != 2) {
		[self _stopReceiveWithStatus:@"HTTP error" code:httpResponse.statusCode];
	}
	else {
		contentTypeHeader = [httpResponse.allHeaderFields objectForKey:@"Content-Type"];
		
		if (contentTypeHeader == nil)
			[self _stopReceiveWithStatus:@"No Content-Type!" code:-1];
		else
			[activeDownload setLength:0];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [activeDownload appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	connectionFinished = YES;
	imageDownloaded = NO;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *downloadedImage = [[UIImage alloc] initWithData:activeDownload];
	self.image = downloadedImage;
	
	NSString *imagePath;
	if (!directory)
		imagePath = [imageName pathInPrivateDirectory];
	else
		imagePath = [imageName pathInDirectory:directory];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:imagePath])
		[activeDownload writeToFile:imagePath atomically:YES];
	
	imageDownloaded = YES;
	connectionFinished = YES;
}


- (void)cancel {
	connectionFinished = YES;
	imageDownloaded = NO;
}

@end
