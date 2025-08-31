#import <Foundation/Foundation.h>
#import "VaultMediaItem.h"

@interface VaultManager : NSObject

+ (instancetype)sharedManager;

- (void)loadVaultItems;
- (void)saveVaultItems;

- (void)addVaultItem:(VaultMediaItem *)item;
- (void)deleteVaultItem:(VaultMediaItem *)item;

- (NSArray<VaultMediaItem *> *)allItems;
- (NSArray<VaultMediaItem *> *)favoriteItems;

@end
