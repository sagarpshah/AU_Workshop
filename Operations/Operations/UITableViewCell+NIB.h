#import "UIView+NIB.h"

@interface UITableViewCell (Extend)  

+ (NSString*)cellID;
+ (id)loadCell;
+ (id)dequeOrCreateInTable:(UITableView*)tableView;

@end
