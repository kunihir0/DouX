#import <UIKit/UIKit.h>
#import "FilterViewController.h"
#import "VaultMediaItem.h"

@interface VaultItemsViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items;

@end