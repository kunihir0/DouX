#import <UIKit/UIKit.h>
#import "VaultMediaItem.h"

@interface PhotoViewController : UIViewController
- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items atIndex:(NSInteger)index;
@end
