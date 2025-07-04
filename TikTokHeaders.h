#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>
#import "BHIManager.h"
#import "SecurityViewController.h"
#import "BHDownload.h"
#import "BHMultipleDownload.h"
#import "JGProgressHUD/JGProgressHUD.h"
#import <Photos/Photos.h>
#import "Settings/ViewController.h"
#import "Settings/PlaybackSpeed.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>
@end

@interface TTKCommentPanelViewController: UIViewController
@end 

@interface AWEUserNameLabel: UILabel
-(void)addVerifiedIcon:(BOOL)arg1;
@end

@interface TTKProfileRootView: UIView
@end


@interface BDImageView: UIImageView
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHandleLongPress;
- (id)bd_baseImage;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@interface AWECommentPanelViewController: UIViewController
@end

@interface TTTAttributedLabel: UILabel 
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHandleLongPress;
@end

@interface AWEPlayInteractionAuthorView: UIView
- (void)addSubview:(id)arg1;
- (NSString *)emojiForCountryCode:(NSString *)countryCode;
@end
@interface SparkViewController: UIViewController
@property(nonatomic, strong, readwrite) NSURL *originURL;
- (void)didTapCloseButton;
@end

@interface AWEAwemeACLItem: NSObject
- (void)setWatermarkType:(NSUInteger)arg1;
- (NSUInteger)watermarkType;
@end

@interface ACCCreationPublishAction: NSObject
- (BOOL)is_open_hd;
- (void)setIs_open_hd:(BOOL)arg1;
- (BOOL)is_have_hd;
- (void)setIs_have_hd:(BOOL)arg1;
@end

@interface AWEMaskInfoModel
- (BOOL)showMask;
- (void)setShowMask:(BOOL)arg1;
@end

@interface UIView (RCTViewUnmounting)
@property(retain, nonatomic) UIViewController *yy_viewController;
@end
@class AWEUserModel;
@interface AWECommentModel: NSObject
@property(retain, nonatomic) AWEUserModel *user;
@property(retain, nonatomic) NSString *content;
@end

@interface AWECommentPanelCell: UITableViewCell
- (void)onLikeAction:(id)arg1;
- (void)onDislikeAction:(id)arg1;
- (void)addHandleLongPress;
- (void)addGPTButton;
- (void)gptButtonHandler:(UIButton *)sender;
- (void)generateGPT:(AWECommentModel *)comment;
@property(retain, nonatomic) AWECommentModel *model;
@end
@interface TikTokCommentImpl_CommentLongPressPanelInternalShareCell: UICollectionViewCell
@end

@interface AWEFeedVideoButton: UIButton
@property(copy, nonatomic, readwrite) NSString *imageNameString;
@end

@interface AWEURLModel : NSObject
@property(retain, nonatomic) NSArray* originURLList;
- (NSURL *)recommendUrl;
- (NSURL *)bestURLtoDownload;
- (NSString *)bestURLtoDownloadFormat;
@end

@interface AWEVideoModel : NSObject
@property(readonly, nonatomic) AWEURLModel *playURL;
@property(readonly, nonatomic) AWEURLModel *downloadURL;
@property(readonly, nonatomic) NSNumber *duration;
@end

@interface AWEMusicModel : NSObject
@property(readonly, nonatomic) AWEURLModel *playURL;
@end

@interface AWEPhotoAlbumPhoto: NSObject
@property(readonly, nonatomic) AWEURLModel *originPhotoURL;
@end

@interface AWEPhotoAlbumModel: NSObject
@property(readonly, nonatomic) NSArray <AWEPhotoAlbumPhoto *> *photos;
@end

@interface AWEAwemeStatisticsModel: NSObject
@property (nonatomic, strong, readwrite) NSNumber *diggCount;
@end

@interface TUXLabel: UILabel 
@end

@interface AWEUserModel: NSObject
@property(nonatomic, copy, readwrite) NSString *bioUrl;
@property(nonatomic, copy, readwrite) NSString *nickname;
@property(nonatomic, copy, readwrite) NSString *signature;
@property(nonatomic, copy, readwrite) NSString *socialName;
@property (nonatomic, strong, readwrite) NSNumber *visibleVideosCount;
@end

@interface AWEAwemeModel : NSObject
@property(nonatomic) BOOL isAds;
@property(retain, nonatomic) AWEVideoModel *video;
@property(retain, nonatomic) id music;
@property (nonatomic, copy, readwrite) NSString *itemID;
@property(retain, nonatomic) AWEPhotoAlbumModel *photoAlbum;
@property(nonatomic) NSString *music_songName;
@property(nonatomic) NSString *music_artistName;
@property(nonatomic, strong, readwrite) AWEAwemeModel *currentPlayingStory;
@property (nonatomic, copy, readwrite) NSString *region;
@property (nonatomic, strong, readwrite) AWEAwemeStatisticsModel *statistics;
@property (nonatomic, strong, readwrite) NSNumber *createTime;
@property (nonatomic, strong, readwrite) AWEUserModel *author;
@property (nonatomic, assign, readwrite) BOOL isUserRecommendBigCard;
+ (id)liveStreamURLJSONTransformer;
+ (id)relatedLiveJSONTransformer;
+ (id)rawModelFromLiveRoomModel:(id)arg1;
+ (id)aweLiveRoom_subModelPropertyKey;
- (void)live_callInitWithDictyCategoryMethod:(id)arg1;
@end

@interface AWEUserWorkCollectionViewCell: UICollectionView
@property (nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSString *)formattedNumber:(NSInteger)number;
- (NSString *)formattedDateStringFromTimestamp:(NSTimeInterval)timestamp;
- (id)contentView;
@end

@interface TTKProfileOtherViewController :UIViewController
@property (nonatomic, strong, readwrite) AWEUserModel *user;
@end

@interface AWESettingItemModel: NSObject
@property(nonatomic, copy, readwrite) NSString *identifier;
@property(nonatomic, copy, readwrite) NSString *title;
@property(nonatomic, copy, readwrite) NSString *detail;
@property(nonatomic, strong, readwrite) UIImage *iconImage;
@property(nonatomic, assign, readwrite) NSUInteger type;
- (instancetype)initWithIdentifier:(NSString *)identifier;
@end

@interface TTKSettingsBaseCellPlugin: NSObject
@property(nonatomic, weak, readwrite) id context;
@property(nonatomic, strong, readwrite) AWESettingItemModel *itemModel;
- (instancetype)initWithPluginContext:(id)context;
@end

@interface AWEBaseListSectionViewModel: NSObject
@property(nonatomic, copy, readwrite) NSArray *modelsArray;
- (void)insertModel:(id)model atIndex:(NSInteger)index animated:(bool)animated;
@end

@interface AWESettingsNormalSectionViewModel: AWEBaseListSectionViewModel
@property(nonatomic, weak, readwrite) id context;
@property(nonatomic, copy, readwrite) NSString *sectionHeaderTitle;
@property(nonatomic, copy, readwrite) NSString *sectionIdentifier;
@end

@interface AWEBaseListViewModel: NSObject
- (NSArray *)sectionViewModelsArray;
@end

@interface AWEPluginBaseViewModel: AWEBaseListViewModel
@end

@interface AWESettingsBaseViewModel: AWEPluginBaseViewModel
@end

@interface TTKSettingsViewModel: AWESettingsBaseViewModel
@end

@interface TIKTOKProfileHeaderViewController: UIViewController
@property(nonatomic, strong) AWEUserModel *user;
@end

@interface TIKTOKProfileHeaderView: UIView
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface AWEProfileImagePreviewView: UIView
@property(strong, nonatomic, readwrite) UIImageView *avatar;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface AWEAwemeBaseViewController: UIViewController
@property(nonatomic, strong, readwrite) AWEAwemeModel *model;
@property (nonatomic, copy, readwrite) NSString *referString;
@property (nonatomic) id interactionController;
@end


@interface TTKFeedInteractionContainerElement: NSObject
- (void)hideAllElements:(BOOL)hide exceptArray:(id)array;
@end

@interface TTKFeedInteractionMainContainerElement: TTKFeedInteractionContainerElement
@end

@interface TTKFeedInteractionLegacyMainContainerElement: TTKFeedInteractionMainContainerElement
@end

@interface AWEPlayPhotoAlbumViewController: UIViewController
@property(nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSIndexPath *)currentIndexPath;
@end

@interface TTKPhotoAlbumFeedCellController: AWEAwemeBaseViewController
{
    AWEPlayPhotoAlbumViewController *_photoAlbumController;
}
@end

@interface TTKPhotoAlbumDetailCellController: AWEAwemeBaseViewController
{
    AWEPlayPhotoAlbumViewController *_photoAlbumController;
}
@end

@interface AWEFeedCellViewController: AWEAwemeBaseViewController
@property (nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSInteger)indexPath;
@end

@interface AWEAwemeDetailCellViewController: AWEAwemeBaseViewController
@end

@interface TTKStoryContainerViewController: UIViewController
@property(nonatomic, strong, readwrite) AWEAwemeModel *model;
@property (nonatomic) id interactionController;
@end
@interface TTKStoryDetailContainerViewController: TTKStoryContainerViewController
@end


@interface AWEFeedViewTemplateCell: UITableViewCell
@property(nonatomic, strong, readwrite) UIViewController *viewController;
@property(nonatomic, strong, readwrite) UIViewController *parentVC;
@property(nonatomic, assign) BOOL elementsHidden;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
@property (nonatomic, retain) UIProgressView *progressView;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHideElementButton;
- (void)hideElementButtonHandler:(UIButton *)sender;
- (void)addDownloadButton;
- (void)addFlexButton;
- (void) downloadButtonHandler:(UIButton *)sender;
- (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)copyDecription:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadPhotos:(TTKPhotoAlbumDetailCellController *)rootVC photoIndex:(unsigned long)index;
- (void)downloadPhotos:(TTKPhotoAlbumDetailCellController *)rootVC;
- (void)tapDownloadVideo;
@end
@interface AWEFeedViewTemplateCell () <BHDownloadDelegate, BHMultipleDownloadDelegate>
@end

@interface AWEFeedViewCell: AWEFeedViewTemplateCell
@end

@interface AWEAwemeDetailTableViewCell: UITableViewCell
@property(nonatomic, strong, readwrite) UIViewController *viewController;
@property(nonatomic, strong, readwrite) UIViewController *parentVC;
@property(nonatomic, assign) BOOL elementsHidden;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
@property (nonatomic, retain) UIProgressView *progressView;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHideElementButton;
- (void)hideElementButtonHandler:(UIButton *)sender;
- (void)addDownloadButton;
- (void) downloadButtonHandler:(UIButton *)sender;
- (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)copyDecription:(AWEAwemeBaseViewController *)rootVC;
@end
@interface AWEAwemeDetailTableViewCell () <BHDownloadDelegate>
@end

@interface TTKStoryDetailTableViewCell: UITableViewCell
@property(nonatomic, strong, readwrite) UIViewController *viewController;
@property(nonatomic, strong, readwrite) UIViewController *parentVC;
@property(nonatomic, assign) BOOL elementsHidden;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
- (void)addHideElementButton;
- (void)hideElementButtonHandler:(UIButton *)sender;
- (void)addDownloadButton;
- (void) downloadButtonHandler:(UIButton *)sender;
- (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)copyDecription:(AWEAwemeBaseViewController *)rootVC;
@end
@interface TTKStoryDetailTableViewCell () <BHDownloadDelegate>
@end

@interface TTKFeedPassthroughStackView: UIStackView
@end

@interface TUXActionSheetAction: NSObject
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *subtitle;
@property(nonatomic) NSString *imageLabel;
@property(nonatomic) UIImage *image;
- (instancetype)initWithStyle:(NSUInteger)style title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image imageLabel:(NSString *)imageLabel handler:(void (^ __nullable)(TUXActionSheetAction *action))handler;
@end

@interface TUXActionSheetController: UIViewController
@property(nonatomic, assign, readwrite) BOOL dismissOnDraggingDown;
@property(nonatomic, strong, readwrite) UITableView *tableView;
- (instancetype)initWithTitle:(NSString *)title;
- (void)addAction:(TUXActionSheetAction *)action;
@end

@interface AWEUIAlertView: UIView
+ (void)showAlertWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle actionBlock:(void (^)(void))actionBlock cancelBlock:(void (^)(void))cancelBlock;
@end

@interface AWEToast: NSObject
+ (void)showSuccess:(NSString *)title;
@end

@interface AWEPlayVideoPlayerController : NSObject
@property(nonatomic) AWEAwemeBaseViewController *container;
- (void)setPlayerSeekTime:(double)arg1 completion:(id)arg2;
@end

@interface TTKSearchEntranceButton: UIButton
@end

@interface AWEPlayInteractionWarningElementView: UIView
- (id)warningImage;
- (id)warningLabel;
@end
@interface AWEFeedContainerViewController: UIViewController
@property(nonatomic, strong, readwrite) TTKSearchEntranceButton *searchEntranceView;
@end

@interface AWENewFeedTableViewController : UIViewController
@property(nonatomic, weak, readwrite) UIViewController *tabContainerController;
@property (nonatomic, assign, readonly) AWEAwemeModel *currentAweme;
- (void)scrollToNextVideo;
- (void)pause;
- (void)stop;
@end

@interface TTKProfileBaseComponentModel : NSObject
@property (nonatomic, strong) NSString *componentID;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray *components;
@property (nonatomic, copy, readwrite) NSDictionary *bizData;
- (NSString *)formattedStringFromNumber:(NSNumber *)number; //new 
- (NSNumber *)numberFromUserDefaultsForKey:(NSString *)key; // new
@end

static BOOL is_iPad() {
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        return YES;
    }
    return NO;
}

static UIViewController * _Nullable _topMostController(UIViewController * _Nonnull cont) {
    UIViewController *topController = cont;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    return (topController != cont ? topController : nil);
}
static UIViewController * _Nonnull topMostController() {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *next = nil;
    while ((next = _topMostController(topController)) != nil) {
        topController = next;
    }
    return topController;
}
