#import <UIKit/UIKit.h>
#import "VaultMediaItem.h"

@interface VaultContentTypesViewController : UITableViewController

- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items andUsername:(NSString *)username;

@end