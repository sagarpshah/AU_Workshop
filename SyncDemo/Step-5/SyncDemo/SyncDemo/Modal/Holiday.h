//
//  Holiday.h
//  SyncDemo
//
//  Created by Ishi Systems on 25/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Holiday : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id observedBy;
@property (nonatomic, retain) NSString * wikipediaLink;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * syncStatus;

@end
