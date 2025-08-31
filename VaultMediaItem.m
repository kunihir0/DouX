#import "VaultMediaItem.h"

@implementation VaultMediaItem

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.internalID forKey:@"internalID"];
    [coder encodeObject:self.filePath forKey:@"filePath"];
    [coder encodeObject:self.creatorUsername forKey:@"creatorUsername"];
    [coder encodeInteger:self.contentType forKey:@"contentType"];
    [coder encodeObject:self.savedDate forKey:@"savedDate"];
    [coder encodeBool:self.isFavorite forKey:@"isFavorite"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _internalID = [coder decodeObjectOfClass:[NSString class] forKey:@"internalID"];
        _filePath = [coder decodeObjectOfClass:[NSString class] forKey:@"filePath"];
        _creatorUsername = [coder decodeObjectOfClass:[NSString class] forKey:@"creatorUsername"];
        _contentType = [coder decodeIntegerForKey:@"contentType"];
        _savedDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"savedDate"];
        _isFavorite = [coder decodeBoolForKey:@"isFavorite"];
    }
    return self;
}

@end
