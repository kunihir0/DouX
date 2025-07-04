#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHIManager: NSObject
+ (BOOL)hideAds;
+ (BOOL)downloadButton;
+ (BOOL)shareSheet;
+ (BOOL)removeWatermark;
+ (BOOL)hideElementButton;
+ (BOOL)uploadRegion;
+ (BOOL)autoPlay;
+ (BOOL)stopPlay;
+ (BOOL)progressBar;
+ (BOOL)transparentCommnet;
+ (BOOL)showUsername;
+ (BOOL)disablePullToRefresh;
+ (BOOL)disableUnsensitive;
+ (BOOL)disableWarnings;
+ (BOOL)disableLive;
+ (BOOL)skipRecommendations;
+ (BOOL)likeConfirmation;
+ (BOOL)likeCommentConfirmation;
+ (BOOL)dislikeCommentConfirmation;
+ (BOOL)followConfirmation;
+ (BOOL)profileSave;
+ (BOOL)profileCopy;
+ (BOOL)profileVideoCount;
+ (BOOL)videoLikeCount;
+ (BOOL)videoUploadDate;
+ (BOOL)alwaysOpenSafari;
+ (BOOL)regionChangingEnabled;
+ (NSNumber *)selectedRegion;
+ (NSNumber *)selectedLiveAction;
+ (BOOL)liveActionEnabled;
+ (BOOL)speedEnabled;
+ (NSNumber *)selectedSpeed;
+ (BOOL)fakeChangesEnabled;
+ (BOOL)fakeVerified;
+ (BOOL)uploadHD;
+ (BOOL)extendedBio;
+ (BOOL)extendedComment;
+ (BOOL)appLock;
+ (BOOL)flexEnabled;
+ (BOOL)llmEnabled;
+ (NSString *)ollamaURL;
+ (NSString *)selectedModel;
+ (NSString *)systemPrompt;
+ (BOOL)streamingResponses;
+ (void)showSaveVC:(id)item;
+ (void)cleanCache;
+ (BOOL)isEmpty:(NSURL *)url;
+ (NSString *)getDownloadingPersent:(float)per;
+ (void)saveMedia:(id)item fileExtension:(id)fileExtension;
@end