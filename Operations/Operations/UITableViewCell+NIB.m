#include "UITableViewCell+NIB.h"

@implementation UITableViewCell (Extend)

+ (id)loadCell
{    
    id object = [super loadView];
    
    if ([object isKindOfClass:self]) {
        UITableViewCell *cell = object;
        [cell setValue:[self cellID] forKey:@"_reuseIdentifier"];	
        return cell;
    }
    
    return nil;
}


+ (NSString*)cellID
{
    return [self description];
}


+ (id)dequeOrCreateInTable:(UITableView*)tableView
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellID]];
    return cell ? cell : [self loadCell];
}

@end
