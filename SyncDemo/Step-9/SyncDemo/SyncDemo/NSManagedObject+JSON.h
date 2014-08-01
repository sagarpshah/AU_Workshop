//
//  NSManagedObject+JSON.h
//  SyncDemo
//
//  Created by Ishi Systems on 01/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

- (NSDictionary *)JSONToCreateObjectOnServer;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end
