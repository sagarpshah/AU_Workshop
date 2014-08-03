#import "ResourceToken.h"

@interface ResourceLoader : NSObject {
	NSOperationQueue *queue;
}

+ (ResourceLoader *)sharedResourceLoader;

- (id<ResourceToken>)threadOnObject:(NSObject *)object forDelegate:(id)delegate withSelector:(SEL)sel;

@end
