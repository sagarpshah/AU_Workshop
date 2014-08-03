#import "ResourceLoader.h"
#import "Operation.h"

static ResourceLoader* sharedResourceLoader = nil;

@implementation ResourceLoader

- (id)init {
	if(![super init]) return nil;
	queue = [NSOperationQueue new];
	[queue setMaxConcurrentOperationCount:2];
	return self;
}

- (id<ResourceToken>)queueOperation:(Operation*)op {
	[queue addOperation:op];
	return op;
}

- (id<ResourceToken>)threadOnObject:(NSObject *)object forDelegate:(id)delegate withSelector:(SEL)sel {
	return [self queueOperation:[[Operation alloc] initWithObject:object withSelector:sel delegate:delegate]];
}

#pragma mark singleton methods

+ (ResourceLoader *)sharedResourceLoader {
	@synchronized(self) {
		if(!sharedResourceLoader) {
			sharedResourceLoader = [ResourceLoader new];
		}
	}
	return sharedResourceLoader;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(!sharedResourceLoader) {
			sharedResourceLoader = [super allocWithZone:zone];
			return sharedResourceLoader;
		} 
	}
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone {	return self; }

@end
