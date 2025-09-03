#import "DouXManager.h"
#import "TikTokHeaders.h"
#import <os/log.h>
#import "VaultManager.h"

static os_log_t douxmanager_log;

@implementation DouXManager

+ (void)load {
    douxmanager_log = os_log_create("com.kunihir0.doux", "DouXManager");
}

+ (BOOL)hideAds {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_ads"];
}
+ (BOOL)downloadButton {
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"download_button"];
}
+ (BOOL)shareSheet {
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"share_sheet"];
}
+ (BOOL)removeWatermark {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_watermark"];
}
+ (BOOL)hideElementButton {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_elements_button"];
}
+ (BOOL)uploadRegion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"upload_region"];
}
+ (BOOL)autoPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_play"];
}
+ (BOOL)stopPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"stop_play"];
}
+ (BOOL)progressBar {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"show_porgress_bar"];
}
+ (BOOL)transparentCommnet {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"transparent_commnet"];
}
+ (BOOL)showUsername {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"show_username"];
}
+ (BOOL)disablePullToRefresh {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"pull_to_refresh"];
}
+ (BOOL)disableUnsensitive {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_unsensitive"];
}
+ (BOOL)disableWarnings {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_warnings"];
}
+ (BOOL)disableLive {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_live"];
}
+ (BOOL)skipRecommendations {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"skip_recommnedations"];
}
+ (BOOL)likeConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_confirm"];
}
+ (BOOL)likeCommentConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_comment_confirm"];
}
+ (BOOL)dislikeCommentConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"dislike_comment_confirm"];
}
+ (BOOL)followConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"follow_confirm"];
}
+ (BOOL)profileSave {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"save_profile"];
}
+ (BOOL)profileCopy {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"copy_profile_information"];
}
+ (BOOL)profileVideoCount {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"uploaded_videos"];
}
+ (BOOL)alwaysOpenSafari {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"openInBrowser"];
}
+ (BOOL)regionChangingEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_region"];
}
+ (BOOL)speedEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"playback_en"];
}
+ (BOOL)liveActionEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_livefunc"];
}
+ (NSNumber *)selectedLiveAction {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"live_action"];
}
+ (NSNumber *)selectedSpeed {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"playback_speed"];
}
+ (BOOL)videoLikeCount {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"video_like_count"];
}
+ (BOOL)videoUploadDate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"video_upload_date"];
}
+ (NSDictionary *)selectedRegion {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"region"];
}
+ (BOOL)fakeChangesEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_fake"];
}
+ (BOOL)fakeVerified {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"fake_verify"];
}
+ (BOOL)extendedBio {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"extended_bio"];
}
+ (BOOL)extendedComment {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"extendedComment"];
}
+ (BOOL)uploadHD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"upload_hd"];
}
+ (BOOL)appLock {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"padlock"];
}
+ (BOOL)flexEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"flex_enabled"];
}

+ (BOOL)showVaultButton {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"show_vault_button"];
}
+ (void)cleanCache {
    NSArray <NSURL *> *DocumentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in DocumentFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"png"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"m4a"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
    }
    
    NSArray <NSURL *> *TempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSTemporaryDirectory()] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in TempFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mov"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"tmp"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"png"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"m4a"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file hasDirectoryPath]) {
            if ([DouXManager isEmpty:file]) {
                [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
            }
        }
    }
}
+ (BOOL)isEmpty:(NSURL *)url {
    NSArray *FolderFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    if (FolderFiles.count == 0) {
        return true;
    } else {
        return false;
    }
}
+ (void)showSaveVC:(NSArray<NSURL *> *)item {
    UIActivityViewController *acVC = [[UIActivityViewController alloc] initWithActivityItems:item applicationActivities:nil];
    if (is_iPad()) {
        acVC.popoverPresentationController.sourceView = topMostController().view;
        acVC.popoverPresentationController.sourceRect = CGRectMake(topMostController().view.bounds.size.width / 2.0, topMostController().view.bounds.size.height / 2.0, 1.0, 1.0);
    }
    [topMostController() presentViewController:acVC animated:true completion:nil];
}

+ (void)saveMedia:(NSURL *)newFilePath withCreator:(NSString *)creator andType:(VaultMediaItemType)type {
    os_log_info(douxmanager_log, "DouXManager saveMedia called with path: %{public}@, creator: %{public}@", newFilePath.path, creator);

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *vaultDirectory = [documentsDirectory stringByAppendingPathComponent:@"Vault"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:vaultDirectory]) {
        [fileManager createDirectoryAtPath:vaultDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *uniqueFileName = [NSString stringWithFormat:@"%@.%@", [[NSUUID UUID] UUIDString], [newFilePath pathExtension]];
    NSString *newPath = [vaultDirectory stringByAppendingPathComponent:uniqueFileName];
    NSURL *newURL = [NSURL fileURLWithPath:newPath];

    [fileManager moveItemAtURL:newFilePath toURL:newURL error:nil];

    VaultMediaItem *item = [[VaultMediaItem alloc] init];
    item.internalID = [[NSUUID UUID] UUIDString];
    item.filePath = newPath;
    item.creatorUsername = creator;
    item.contentType = type;
    item.savedDate = [NSDate date];
    item.isFavorite = NO;

    [[VaultManager sharedManager] addVaultItem:item];
}

+ (void)saveMedia:(NSURL *)newFilePath {
    os_log_error(douxmanager_log, "Deprecated saveMedia: called. Please update to saveMedia:withCreator:andType:");
}

+ (NSString *)getDownloadingPersent:(float)per {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *number = [NSNumber numberWithFloat:per];
    return [numberFormatter stringFromNumber:number];
}
@end