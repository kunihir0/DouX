# BHTikTok++ Coding Style Guide

## 📋 Table of Contents

- [Objective-C Style Guide](#objective-c-style-guide)
- [Logos Hook Guidelines](#logos-hook-guidelines)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)

## 🎯 Objective-C Style Guide

### 1. File Organization

```objective-c
// Header file structure
#import <SystemFramework/SystemFramework.h>
#import "ProjectHeaders.h"

// Constants
extern NSString * const BHConstantName;

// Protocol definitions
@protocol BHProtocolName <NSObject>
// Protocol methods
@end

// Class interface
@interface BHClassName : NSObject
// Public properties and methods
@end
```

### 2. Naming Conventions

```objective-c
// Classes: PascalCase with BH prefix
@interface BHDownloadManager : NSObject

// Methods: camelCase with descriptive names
- (void)downloadFileWithURL:(NSURL *)url completion:(void(^)(BOOL success))completion;

// Properties: camelCase
@property (nonatomic, strong) NSString *downloadDirectory;

// Constants: PascalCase with prefix
extern NSString * const BHDownloadDidCompleteNotification;

// Enum: PascalCase
typedef NS_ENUM(NSInteger, BHDownloadStatus) {
    BHDownloadStatusPending,
    BHDownloadStatusInProgress,
    BHDownloadStatusCompleted,
    BHDownloadStatusFailed
};
```

#### Class Naming
- **Prefix**: All custom classes must use the `BH` prefix
- **Style**: PascalCase (e.g., `BHDownloadManager`, `BHSettingsViewController`)
- **Descriptive**: Names should clearly indicate the class purpose

#### Method Naming
- **Style**: camelCase starting with lowercase
- **Descriptive**: Include parameter types in method names when helpful
- **Consistency**: Follow Apple's naming conventions

```objective-c
// Good
- (void)downloadFileWithURL:(NSURL *)url completion:(BHDownloadCompletion)completion;
- (BOOL)validateInputWithString:(NSString *)input error:(NSError **)error;

// Avoid
- (void)download:(NSURL *)url completion:(BHDownloadCompletion)completion;
- (BOOL)validate:(NSString *)input error:(NSError **)error;
```

#### Property Naming
- **Style**: camelCase
- **Attributes**: Always specify memory management attributes
- **Nullability**: Use nullability annotations where appropriate

```objective-c
@property (nonatomic, strong, nullable) NSString *optionalTitle;
@property (nonatomic, strong, nonnull) NSURL *requiredURL;
@property (nonatomic, weak, nullable) id<BHDelegate> delegate;
@property (nonatomic, assign) BOOL isEnabled;
```

### 3. Memory Management

```objective-c
// Use strong/weak appropriately
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id<BHDelegate> delegate;

// Avoid retain cycles in blocks
__weak typeof(self) weakSelf = self;
[self.downloadManager downloadWithCompletion:^(BOOL success) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) return;
    [strongSelf handleDownloadCompletion:success];
}];
```

#### Block Retain Cycle Prevention
Always use weak-strong pattern in blocks to prevent retain cycles:

```objective-c
// Template
__weak typeof(self) weakSelf = self;
[object performOperationWithCompletion:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) return;
    // Use strongSelf here
}];
```

#### Property Attributes Guidelines
- **strong**: For owned objects (default for object properties)
- **weak**: For delegates, parent references, and breaking retain cycles
- **copy**: For NSString, NSArray, NSDictionary, and blocks
- **assign**: For primitive types and non-object properties

### 4. Code Formatting

#### Indentation and Spacing
- **Indentation**: 4 spaces (no tabs)
- **Line Length**: Maximum 120 characters
- **Spacing**: Single space after control flow keywords

```objective-c
// Method implementations
- (void)methodWithFirstParameter:(id)firstParam 
                 secondParameter:(id)secondParam {
    if (condition) {
        // Implementation
    }
}

// Conditional statements
if (condition) {
    // Code
} else if (otherCondition) {
    // Code
} else {
    // Code
}

// Loops
for (NSInteger i = 0; i < count; i++) {
    // Code
}

while (condition) {
    // Code
}
```

#### Bracket Placement
- Opening brackets on the same line for methods, conditionals, and loops
- Closing brackets on their own line, aligned with the opening statement

## 🔧 Logos Hook Guidelines

### 1. Hook Organization

```objective-c
// Group related hooks together
#pragma mark - Download System Hooks

%hook AWEFeedViewTemplateCell
- (void)configWithModel:(id)model {
    %orig;
    if ([BHIManager downloadButton]) {
        [self addDownloadButton];
    }
}
%end

#pragma mark - Region Spoofing Hooks

%hook CTCarrier
- (NSString *)mobileCountryCode {
    if ([BHIManager regionChangingEnabled]) {
        NSDictionary *selectedRegion = [BHIManager selectedRegion];
        return selectedRegion[@"mcc"];
    }
    return %orig;
}
%end
```

#### Hook Structure
- **Pragma Marks**: Use `#pragma mark -` to organize hook sections
- **Logical Grouping**: Group related hooks together
- **Clear Naming**: Hook sections should have descriptive names

### 2. Safe Hook Practices

```objective-c
// Always check conditions before modifying behavior
%hook SomeClass
- (void)someMethod {
    if (![BHIManager featureEnabled]) {
        return %orig;
    }
    
    // Feature implementation
    // Always provide fallback to original behavior
    %orig;
}
%end

// Use %new sparingly and document thoroughly
%new - (void)customMethod {
    // Custom implementation
}
```

#### Hook Safety Rules
1. **Always call %orig**: Unless you have a specific reason not to
2. **Feature Flags**: Check if features are enabled before applying modifications
3. **Graceful Degradation**: Provide fallback to original behavior
4. **Minimal Impact**: Only hook what's necessary

#### %new Method Guidelines
- **Sparingly Used**: Only when absolutely necessary
- **Well Documented**: Explain why the new method is needed
- **Namespace Aware**: Use BH prefix for new methods to avoid conflicts

```objective-c
%new - (void)bh_customDownloadAction {
    // Implementation
}
```

### 3. Hook Performance Considerations

```objective-c
// Cache expensive operations
%hook ExpensiveClass
- (id)expensiveMethod {
    static id cachedResult = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachedResult = %orig;
    });
    return cachedResult;
}
%end

// Avoid hooks in performance-critical paths
%hook HighFrequencyMethod
- (void)methodCalledVeryOften {
    // Keep implementation minimal
    if ([BHIManager criticalFeatureEnabled]) {
        // Minimal processing only
    }
    %orig;
}
%end
```

## ⚠️ Error Handling

### 1. Defensive Programming

```objective-c
// Always handle errors gracefully
- (BOOL)downloadFileWithURL:(NSURL *)url error:(NSError **)error {
    if (!url) {
        if (error) {
            *error = [NSError errorWithDomain:BHErrorDomain 
                                         code:BHErrorInvalidURL 
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL provided"}];
        }
        return NO;
    }
    
    // Implementation
    return YES;
}
```

### 2. Error Domains and Codes

```objective-c
// Define error domains
extern NSString * const BHErrorDomain;
extern NSString * const BHDownloadErrorDomain;
extern NSString * const BHSettingsErrorDomain;

// Define error codes
typedef NS_ENUM(NSInteger, BHErrorCode) {
    BHErrorUnknown = 0,
    BHErrorInvalidURL,
    BHErrorNetworkUnavailable,
    BHErrorFileSystemError,
    BHErrorPermissionDenied
};
```

### 3. Graceful Error Recovery

```objective-c
- (void)attemptDownloadWithURL:(NSURL *)url {
    NSError *error;
    BOOL success = [self downloadFileWithURL:url error:&error];
    
    if (!success) {
        // Log error for debugging
        NSLog(@"Download failed: %@", error.localizedDescription);
        
        // Provide user feedback
        [self showErrorAlert:error];
        
        // Attempt recovery if possible
        [self handleDownloadError:error];
    }
}
```

## 📏 Best Practices

### 1. Constants and Magic Numbers

```objective-c
// Use constants instead of magic numbers
static const NSTimeInterval kDefaultDownloadTimeout = 30.0;
static const NSInteger kMaxRetryAttempts = 3;
static const CGFloat kProgressUpdateInterval = 0.1;

// Group related constants
typedef struct {
    NSTimeInterval timeout;
    NSInteger maxRetries;
    CGFloat updateInterval;
} BHDownloadConfiguration;
```

### 2. Documentation and Comments

```objective-c
/**
 * Downloads a file from the specified URL with progress tracking.
 *
 * @param url The URL to download from. Must be a valid HTTP/HTTPS URL.
 * @param progressBlock Called periodically with download progress (0.0-1.0).
 * @param completion Called when download completes or fails.
 * @return YES if download started successfully, NO otherwise.
 *
 * @note This method performs downloads asynchronously.
 * @warning Ensure URL validity before calling.
 * @since 1.5.0
 */
- (BOOL)downloadFileWithURL:(NSURL *)url
                   progress:(BHProgressBlock)progressBlock
                 completion:(BHCompletionBlock)completion;
```

### 3. Code Organization

```objective-c
@implementation BHDownloadManager

#pragma mark - Lifecycle

- (instancetype)init {
    // Initialization
}

- (void)dealloc {
    // Cleanup
}

#pragma mark - Public Methods

- (void)startDownload {
    // Public interface
}

#pragma mark - Private Methods

- (void)internalMethod {
    // Private implementation
}

#pragma mark - Delegate Methods

- (void)delegateMethod {
    // Delegate implementations
}

@end
```

### 4. Thread Safety

```objective-c
@interface BHDownloadManager ()
@property (nonatomic, strong) dispatch_queue_t downloadQueue;
@end

@implementation BHDownloadManager

- (instancetype)init {
    if (self = [super init]) {
        _downloadQueue = dispatch_queue_create("com.bhtiktok.download", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)performDownload {
    dispatch_async(self.downloadQueue, ^{
        // Background work
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI updates on main queue
        });
    });
}

@end
```

### 5. Type Safety

```objective-c
// Use specific types instead of id when possible
- (NSArray<NSURL *> *)downloadURLs; // Instead of NSArray *
- (NSDictionary<NSString *, NSNumber *> *)downloadProgress; // Instead of NSDictionary *

// Use nullability annotations
- (nullable NSString *)titleForDownload:(nonnull NSURL *)url;

// Use generics for collections
@property (nonatomic, strong) NSMutableArray<BHDownload *> *activeDownloads;
```

---

## 📝 Enforcement

This style guide is enforced through:
- **Code Review**: All pull requests are reviewed for style compliance
- **Automated Tools**: Where possible, automated formatting tools are used
- **Documentation**: Style violations should be documented and addressed

## 🔄 Updates

This style guide is a living document and will be updated as the project evolves. Contributors are encouraged to suggest improvements.

---

*Last updated: January 2025*