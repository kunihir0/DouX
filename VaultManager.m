#import "VaultManager.h"
#import <Photos/Photos.h>
#import <CommonCrypto/CommonCrypto.h>
#import "JGProgressHUD.h"

#define kEncryptionKeySaltKey @"vault_encryption_salt"
#define kVaultVersionKey @"vault_version"
#define kVaultItemsKey @"vault_items"

@interface VaultManager ()
@property (nonatomic, strong) NSMutableArray<VaultMediaItem *> *items;
@property (nonatomic, strong) NSArray<VaultMediaItem *> *legacyItems;
@property (nonatomic, strong) NSData *encryptionKey;
@property (nonatomic, assign) BOOL encryptionEnabled;
@property (nonatomic, assign) BOOL isLegacy;
@end

@implementation VaultManager

@synthesize legacyItems = _legacyItems;
@synthesize encryptionEnabled = _encryptionEnabled;
@synthesize isUnlocked = _unlocked;
@synthesize isLegacy = _isLegacy;
@synthesize vaultPath = _vaultPath;

+ (instancetype)sharedManager {
    static VaultManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _vaultPath = [documentsDirectory stringByAppendingPathComponent:@"vault.dat"];
        self.encryptionEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"vault_encryption_enabled"];
        [self loadVaultItems];
    }
    return self;
}

- (void)loadVaultItems {
    NSData *data = [NSData dataWithContentsOfFile:self.vaultPath];
    if (data) {
        if (self.encryptionEnabled && !self.isUnlocked) {
            // Don't load items if the vault is locked
            return;
        }
        
        if (self.encryptionEnabled && self.encryptionKey) {
            data = [self crypt:data operation:kCCDecrypt];
        }
        
        id unarchivedObject = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:nil];
        if ([unarchivedObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *vaultDict = (NSDictionary *)unarchivedObject;
            if (vaultDict[kVaultVersionKey]) {
                self.items = [vaultDict[kVaultItemsKey] mutableCopy];
                self.isLegacy = NO;
            } else {
                // This should not happen with the new structure
                self.legacyItems = (NSArray *)unarchivedObject;
                self.isLegacy = YES;
            }
        } else if ([unarchivedObject isKindOfClass:[NSArray class]]) {
            self.legacyItems = unarchivedObject;
            self.isLegacy = YES;
        }
    }
}

- (void)saveVaultItems {
    NSDictionary *vaultDict = @{kVaultVersionKey: @2, kVaultItemsKey: self.items};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:vaultDict requiringSecureCoding:YES error:nil];
    if (self.encryptionEnabled && self.encryptionKey) {
        data = [self crypt:data operation:kCCEncrypt];
    }
    [data writeToFile:self.vaultPath atomically:YES];
}

- (void)addVaultItem:(VaultMediaItem *)item {
    if (self.encryptionEnabled && self.encryptionKey) {
        NSData *fileData = [NSData dataWithContentsOfFile:item.filePath];
        NSData *encryptedData = [self crypt:fileData operation:kCCEncrypt];
        [encryptedData writeToFile:item.filePath atomically:YES];
    }
    [self.items addObject:item];
    [self saveVaultItems];
}

- (void)deleteVaultItem:(VaultMediaItem *)item {
    [[NSFileManager defaultManager] removeItemAtPath:item.filePath error:nil];
    [self.items removeObject:item];
    [self saveVaultItems];
}

- (NSArray<VaultMediaItem *> *)allItems {
    return [self.items copy];
}

- (NSArray<VaultMediaItem *> *)favoriteItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    return [self.items filteredArrayUsingPredicate:predicate];
}

- (BOOL)isItemInVaultWithID:(NSString *)itemID {
    for (VaultMediaItem *item in self.items) {
        if ([item.internalID isEqualToString:itemID]) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary<NSString *, NSArray<VaultMediaItem *> *> *)groupedItems {
    NSMutableDictionary<NSString *, NSMutableArray<VaultMediaItem *> *> *grouped = [NSMutableDictionary dictionary];
    for (VaultMediaItem *item in self.items) {
        NSString *creator = item.creatorUsername;
        if (creator) {
            NSMutableArray<VaultMediaItem *> *userItems = grouped[creator];
            if (!userItems) {
                userItems = [NSMutableArray array];
                grouped[creator] = userItems;
            }
            [userItems addObject:item];
        }
    }
    return grouped;
}

- (void)saveLegacyItemsToPhotosWithCompletion:(void (^)(BOOL success))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        for (VaultMediaItem *item in self.legacyItems) {
            if (item.contentType == VaultMediaItemTypeVideo) {
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:item.filePath]];
            } else if (item.contentType == VaultMediaItemTypePhoto) {
                [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:item.filePath]];
            }
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self deleteLegacyVault];
        }
        if (completion) {
            completion(success);
        }
    }];
}

- (void)deleteLegacyVault {
    self.legacyItems = nil;
    self.isLegacy = NO;
    [[NSFileManager defaultManager] removeItemAtPath:self.vaultPath error:nil];
}

- (void)exportItemsToPhotoLibrary:(NSArray<VaultMediaItem *> *)items completion:(void (^)(BOOL))completion {
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedbackGenerator impactOccurred];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            for (VaultMediaItem *item in items) {
                NSData *data = [NSData dataWithContentsOfFile:item.filePath];
                if (self.encryptionEnabled) {
                    data = [self crypt:data operation:kCCDecrypt];
                }
                
                NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:item.filePath.lastPathComponent];
                [data writeToURL:[NSURL fileURLWithPath:tempPath] atomically:YES];
                
                if (item.contentType == VaultMediaItemTypeVideo) {
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:tempPath]];
                } else if (item.contentType == VaultMediaItemTypePhoto) {
                    [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:tempPath]];
                }
            }
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    for (VaultMediaItem *item in items) {
                        [self deleteVaultItem:item];
                    }
                }
                if (completion) {
                    completion(success);
                }
            });
        }];
    });
}

#pragma mark - Encryption

- (void)processAllFilesWithOperation:(CCOperation)operation withHUD:(JGProgressHUD *)hud completion:(void (^)(BOOL))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float totalFiles = self.items.count;
        float processedFiles = 0;
        
        for (VaultMediaItem *item in self.items) {
            NSData *fileData = [NSData dataWithContentsOfFile:item.filePath];
            NSData *processedData = [self crypt:fileData operation:operation];
            [processedData writeToFile:item.filePath atomically:YES];
            
            processedFiles++;
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = processedFiles / totalFiles;
            });
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        }
    });
}

- (void)enableEncryptionWithPassword:(NSString *)password completion:(void (^)(BOOL success))completion {
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedbackGenerator impactOccurred];
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = @"Encrypting...";
    [hud showInView:[[[UIApplication sharedApplication] keyWindow] rootViewController].view];
    
    NSData *salt = [self generateSalt];
    [[NSUserDefaults standardUserDefaults] setObject:salt forKey:kEncryptionKeySaltKey];
    self.encryptionKey = [self deriveKeyFromPassword:password salt:salt];
    _encryptionEnabled = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"vault_encryption_enabled"];
    [self processAllFilesWithOperation:kCCEncrypt withHUD:hud completion:^(BOOL success) {
        [self saveVaultItems];
        _unlocked = YES;
        [hud dismiss];
        if (completion) {
            completion(YES);
        }
    }];
}

- (void)disableEncryptionWithPassword:(NSString *)password completion:(void (^)(BOOL success))completion {
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedbackGenerator impactOccurred];
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = @"Decrypting...";
    [hud showInView:[[[UIApplication sharedApplication] keyWindow] rootViewController].view];
    
    NSData *salt = [[NSUserDefaults standardUserDefaults] objectForKey:kEncryptionKeySaltKey];
    NSData *key = [self deriveKeyFromPassword:password salt:salt];
    
    NSData *vaultData = [NSData dataWithContentsOfFile:self.vaultPath];
    NSData *decryptedData = [self crypt:vaultData operation:kCCDecrypt withKey:key];

    if (decryptedData) {
        self.encryptionKey = key;
        [self processAllFilesWithOperation:kCCDecrypt withHUD:hud completion:^(BOOL success) {
            _encryptionEnabled = NO;
            self.encryptionKey = nil;
            _unlocked = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEncryptionKeySaltKey];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"vault_encryption_enabled"];
            [self saveVaultItems];
            [hud dismiss];
            if (completion) {
                completion(YES);
            }
        }];
    } else {
        [hud dismiss];
        if (completion) {
            completion(NO);
        }
    }
}

- (BOOL)unlockWithPassword:(NSString *)password {
    NSData *salt = [[NSUserDefaults standardUserDefaults] objectForKey:kEncryptionKeySaltKey];
    NSData *key = [self deriveKeyFromPassword:password salt:salt];
    
    NSData *vaultData = [NSData dataWithContentsOfFile:self.vaultPath];
    NSData *decryptedData = [self crypt:vaultData operation:kCCDecrypt withKey:key];
    
    if (decryptedData) {
        id unarchivedObject = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:decryptedData error:nil];
        if (unarchivedObject) {
            self.encryptionKey = key;
            _unlocked = YES;
            [self loadVaultItems];
            return YES;
        }
    }
    
    return NO;
}

- (NSData *)deriveKeyFromPassword:(NSString *)password salt:(NSData *)salt {
    uint8_t derivedKey[kCCKeySizeAES256];
    CCKeyDerivationPBKDF(kCCPBKDF2, [password UTF8String], password.length, [salt bytes], salt.length, kCCPRFHmacAlgSHA256, 10000, derivedKey, kCCKeySizeAES256);
    return [NSData dataWithBytes:derivedKey length:kCCKeySizeAES256];
}

- (NSData *)generateSalt {
    uint8_t salt[8];
    int status = SecRandomCopyBytes(kSecRandomDefault, 8, salt);
    if (status == errSecSuccess) {
        return [NSData dataWithBytes:salt length:8];
    }
    return nil;
}

- (NSData *)crypt:(NSData *)data operation:(CCOperation)operation {
    return [self crypt:data operation:operation withKey:self.encryptionKey];
}

- (NSData *)crypt:(NSData *)data operation:(CCOperation)operation withKey:(NSData *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getBytes:keyPtr length:sizeof(keyPtr)];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    
    free(buffer);
    return nil;
}

@end