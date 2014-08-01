//
//  NSManagedObject+JSON.m
//  SyncDemo
//
//  Created by Ishi Systems on 01/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "NSManagedObject+JSON.h"

@implementation NSManagedObject (JSON)

- (NSDictionary *)JSONToCreateObjectOnServer
{
    @throw [NSException exceptionWithName:@"JSONStringToCreateObjectOnServer Not Overridden" reason:@"Must override JSONStringToCreateObjectOnServer on NSManagedObject class" userInfo:nil];
    return nil;
}

@end
