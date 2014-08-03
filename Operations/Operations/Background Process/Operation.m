#import "Operation.h"
#import "ResourceToken.h"

@implementation Operation

@synthesize object;

- (id)initWithObject:(NSObject *)_object withSelector:(SEL)_selector delegate:(id)_delegate {
	if(![super init]) return nil;
	self.object = _object;
	selector = _selector;
	delegate = _delegate;
	return self;
}

- (void)cancel {
	delegate = nil;
	if ([object respondsToSelector:@selector(cancel)])
		[object performSelector:@selector(cancel)];
	[super cancel];
}

#define RETURN_IF_CANCELED if ([self isCancelled]) { return; }

- (void)notifyDelegate:(NSError*)error {
	RETURN_IF_CANCELED
	if(error) {
		if ([delegate respondsToSelector:@selector(loadingResourceDidFinishWithError: forResource:)])
			[delegate performSelector:@selector(loadingResourceDidFinishWithError:forResource:) withObject:error withObject:object];
	} else {
		if ([delegate respondsToSelector:@selector(loadingResourceDidFinish:)])
			[delegate performSelector:@selector(loadingResourceDidFinish:) withObject:object];
	}
}


- (void)main {
	@autoreleasepool {
        RETURN_IF_CANCELED
        NSError *error = [object performSelector:selector];
        RETURN_IF_CANCELED
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:error waitUntilDone:NO];
    }
} 

- (void)dealloc
{
	self.object = nil;
}

@end