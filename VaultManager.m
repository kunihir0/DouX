#import "VaultManager.h"

@interface VaultManager ()
@property (nonatomic, strong) NSMutableArray<VaultMediaItem *> *items;
@property (nonatomic, strong) NSString *vaultPath;
@end

@implementation VaultManager

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
        [self loadVaultItems];
    }
    return self;
}

- (void)loadVaultItems {
    NSData *data = [NSData dataWithContentsOfFile:self.vaultPath];
    if (data) {
        NSSet *classes = [NSSet setWithArray:@[[NSMutableArray class], [VaultMediaItem class]]];
        self.items = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:nil];
    }
}

- (void)saveVaultItems {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:YES error:nil];
    [data writeToFile:self.vaultPath atomically:YES];
}

- (void)addVaultItem:(VaultMediaItem *)item {
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

@end
