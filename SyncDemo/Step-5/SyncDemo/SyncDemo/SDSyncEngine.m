//
//  SDSyncEngine.m
//  SyncDemo
//
//  Created by Ishi Systems on 30/07/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "SDSyncEngine.h"
#import "SDCoreDataController.h"

@interface SDSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

NSString * const kSDSyncEngineInitialCompleteKey = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SDSyncEngineSyncCompleted";

@implementation SDSyncEngine

@synthesize registeredClassesToSync = _registeredClassesToSync;
@synthesize syncInProgress = _syncInProgress;
@synthesize dateFormatter = _dateFormatter;

+ (SDSyncEngine *)sharedEngine
{
    static SDSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SDSyncEngine alloc] init];
    });
    
    return sharedEngine;
}

- (void)startSync
{
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES];
        });
    }
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass
{
    if (_registeredClassesToSync == nil) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            NSLog(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
        }
    } else {
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
    }
}

- (BOOL)initialSyncComplete
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)executeSyncCompletedOperations
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSDSyncEngineSyncCompletedNotificationName object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName
{
    __block NSDate *date = nil;
    //
    // Create a new fetch request for the specified entity
    //
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    //
    // Set the sort descriptors on the request to sort by updatedAt in descending order
    //
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    //
    // You are only interested in 1 result so limit the request to 1
    //
    [request setFetchLimit:1];
    [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject]) {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}

- (void)newManagedObjectWithClassName:(NSString *)className forRecord:(NSDictionary *)record
{
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[SDCoreDataController sharedInstance] backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:SDObjectSynced] forKey:@"syncStatus"];
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record
{
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject
{
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else {
        [managedObject setValue:value forKey:key];
    }
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate
{
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest *request = [[SDAFParseAPIClient sharedClient] GETRequestForAllRecordsOfClass:className updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[SDAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self writeJSONResponse:responseObject toDiskForClassWithName:className];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request for class %@ failed with error: %@", className, error);
        }];
        
        [operations addObject:operation];
    }
    
    [[SDAFParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations completed");
        // 2
        // Need to process JSON records into Core Data
    }];
}

- (void)initializeDateFormatter
{
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString
{
    [self initializeDateFormatter];
    // NSDateFormatter does not like ISO 8601 so strip the milliseconds and timezone
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date
{
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000Z"];
    
    return dateString;
}

#pragma mark - File Management

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return url;
}

- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className
{
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // remove NSNulls and try again...
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES]) {
            NSLog(@"Failed all attempts to save response to disk: %@", response);
        }
    }
}

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className
{
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key
{
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}

- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className
{
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        NSLog(@"Unable to delete JSON Records at %@, reason: %@", url, error);
    }
}

@end
