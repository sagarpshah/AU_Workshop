//
//  SDSyncEngine.h
//  SyncDemo
//
//  Created by Ishi Systems on 30/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDAFParseAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;

- (void)startSync;

@end
