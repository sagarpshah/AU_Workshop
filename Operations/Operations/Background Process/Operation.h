#import "ResourceToken.h"

@interface Operation: NSOperation <ResourceToken> {
	NSObject *object;
	SEL selector;
	id delegate;
}

@property (nonatomic, strong) NSObject *object;

- (id)initWithObject:(NSObject *)_object withSelector:(SEL)_selector delegate:(id)delegate;

@end
