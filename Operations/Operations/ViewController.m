//
//  ViewController.m
//  Operations
//
//  Created by Ishi Systems on 03/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)addImagesInArray
{
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120509154705", @"imageURL", @"Are you board?", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/629/228/44822926:jpeg_preview_small.jpg?20120509181018#sthash.k2DCGxZc.dpuf", @"imageURL", @"Get a life @marcozp", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/116/367/44763611:jpeg_preview_small.jpg?20120509101749#sthash.k2DCGxZc.dpuf", @"imageURL", @"Is that full version or free?", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/340/086/44680043:jpeg_preview_small.jpg?20120509180118#sthash.k2DCGxZc.dpuf", @"imageURL", @"Narwhalbird", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/666/645/43546666:jpeg_preview_small.jpg?20120412153140#sthash.k2DCGxZc.dpuf", @"imageURL", @"@_peter_g_ 😁", @"text", nil]];
    
    
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_21629934_75sq_1339375325.jpg", @"imageURL", @"aha lovin it mike 👌", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_145221111_75sq_1337563791.jpg", @"imageURL", @"Cool", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_41693311_75sq_1334526308.jpg", @"imageURL", @"That's awesome", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_4870920_75sq_1308961146.jpg", @"imageURL", @"King Of Harajuku, #WayCooler", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_177058037_75sq_1341742100.jpg", @"imageURL", @"that_australian_chick", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_176435079_75sq_1341206259.jpg", @"imageURL", @"As ggarcia29 said: Beautifully blondies ;-)", @"text", nil]];
    [imagesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://images.instagram.com/profiles/profile_184160343_75sq_1340168077.jpg", @"imageURL", @"…beautiful girl", @"text", nil]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        imagesArray = [[NSMutableArray alloc] init];
        
        [self addImagesInArray];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [imagesArray objectAtIndex:indexPath.row];
    
    MyTableViewCell *cell = [MyTableViewCell dequeOrCreateInTable:tableView];
    
    NSString *fileName = [NSString stringWithFormat:@"%d.jpg", indexPath.row];
    [cell downloadImageWithURLString:[dict objectForKey:@"imageURL"] fileNameToSave:fileName];
    
    cell.textLabel.text = [dict objectForKey:@"text"];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dealloc
{
    self.imagesTableView = nil;
}

@end
