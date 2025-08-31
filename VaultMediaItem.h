#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VaultMediaItemType) {
    VaultMediaItemTypePhoto,
    VaultMediaItemTypeVideo
};

@interface VaultMediaItem : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *internalID;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *creatorUsername;
@property (nonatomic, assign) VaultMediaItemType contentType;
@property (nonatomic, strong) NSDate *savedDate;
@property (nonatomic, assign) BOOL isFavorite;

@end
