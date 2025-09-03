#import <Foundation/Foundation.h>
#import "VaultMediaItem.h"
#import <CommonCrypto/CommonCrypto.h>

@interface VaultManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign, readonly) BOOL isLegacy;
@property (nonatomic, strong, readonly) NSArray<VaultMediaItem *> *legacyItems;
@property (nonatomic, assign, readonly) BOOL encryptionEnabled;
@property (nonatomic, assign, readonly) BOOL isUnlocked;
@property (nonatomic, strong, readonly) NSString *vaultPath;

- (void)loadVaultItems;
- (void)saveVaultItems;

- (void)addVaultItem:(VaultMediaItem *)item;
- (void)deleteVaultItem:(VaultMediaItem *)item;
- (BOOL)isItemInVaultWithID:(NSString *)itemID;

- (void)enableEncryptionWithPassword:(NSString *)password completion:(void (^)(BOOL success))completion;
- (void)disableEncryptionWithPassword:(NSString *)password completion:(void (^)(BOOL success))completion;
- (BOOL)unlockWithPassword:(NSString *)password;

- (NSArray<VaultMediaItem *> *)allItems;
- (NSArray<VaultMediaItem *> *)favoriteItems;
- (NSDictionary<NSString *, NSArray<VaultMediaItem *> *> *)groupedItems;

- (void)saveLegacyItemsToPhotosWithCompletion:(void (^)(BOOL success))completion;
- (void)deleteLegacyVault;
- (void)exportItemsToPhotoLibrary:(NSArray<VaultMediaItem *> *)items completion:(void (^)(BOOL success))completion;

- (NSData *)crypt:(NSData *)data operation:(CCOperation)operation;

@end
