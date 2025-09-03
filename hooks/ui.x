#import "TikTokHeaders.h"
#import "JGProgressHUD.h"
#import "VaultViewController.h"
#import "DouXDownload.h"
#import "DouXMultipleDownload.h"
#import <os/log.h>
#import "common.h"

%hook TTKCommentPanelViewController
- (void)viewDidLoad {
    %orig;
    if ([DouXManager transparentCommnet]){
        UIView *commnetView = [self view];
        [commnetView setAlpha:0.90];
    }
}
%end

%hook AWEAwemeModel // no ads, show porgress bar
- (id)initWithDictionary:(id)arg1 error:(id *)arg2 {
    id orig = %orig;
    return [DouXManager hideAds] && self.isAds ? nil : orig;
}
- (id)init {
    id orig = %orig;
    return [DouXManager hideAds] && self.isAds ? nil : orig;
}

- (BOOL)progressBarDraggable {
    return [DouXManager progressBar] || %orig;
}
- (BOOL)progressBarVisible {
    return [DouXManager progressBar] || %orig;
}
- (void)live_callInitWithDictyCategoryMethod:(id)arg1 {
    if (![DouXManager disableLive]) {
        %orig;
    }
}
+ (id)liveStreamURLJSONTransformer {
    if ([DouXManager disableLive]) {
        return nil;
    }
    return %orig;
}
+ (id)relatedLiveJSONTransformer {
    if ([DouXManager disableLive]) {
        return nil;
    }
    return %orig;
}
+ (id)rawModelFromLiveRoomModel:(id)arg1 {
    if ([DouXManager disableLive]) {
        return nil;
    }
    return %orig;
}
+ (id)aweLiveRoom_subModelPropertyKey {
    if ([DouXManager disableLive]) {
        return nil;
    }
    return %orig;
}
%end

%hook AWEPlayInteractionWarningElementView
- (id)warningImage {
    if ([DouXManager disableWarnings]) {
        return nil;
    }
    return %orig;
}
- (id)warningLabel {
    if ([DouXManager disableWarnings]) {
        return nil;
    }
    return %orig;
}
%end

%hook TUXLabel
- (void)setText:(NSString*)arg1 {
    if ([DouXManager showUsername]) {
        if ([[[self superview] superview] isKindOfClass:%c(AWEPlayInteractionAuthorUserNameButton)]){
            AWEFeedCellViewController *rootVC = [[[self superview] superview] yy_viewController];
            AWEAwemeModel *model = rootVC.model;
            AWEUserModel *authorModel = model.author;
            NSString *nickname = authorModel.nickname;
            NSString *username = authorModel.socialName;
            %orig(username);
        }else {
            %orig;
        }
    }else {
        %orig;
    }
}
%end

%hook AWENewFeedTableViewController
- (BOOL)disablePullToRefreshGestureRecognizer {
    if ([DouXManager disablePullToRefresh]){
        return 1;
    }
    return %orig;
}

%end

%hook AWEMaskInfoModel // Disable Unsensitive Content
- (BOOL)showMask {
    if ([DouXManager disableUnsensitive]) {
        return 0;
    }
    return %orig;
}
- (void)setShowMask:(BOOL)arg1 {
    if ([DouXManager disableUnsensitive]) {
        %orig(0);
    }
    else {
        %orig;
    }
}
%end

%hook AWEAwemeACLItem // remove default watermark
- (void)setWatermarkType:(NSUInteger)arg1 {
    if ([DouXManager removeWatermark]){
        %orig(1);
    }
    else { 
        %orig;
    }
    
}
- (NSUInteger)watermarkType {
    if ([DouXManager removeWatermark]){
        return 1;
    }
    return %orig;
}
%end

%hook UIButton // follow confirmation broken 
- (void)_onTouchUpInside {
    if ([DouXManager followConfirmation] && [self.currentTitle isEqualToString:@"Follow"]) {
        showConfirmation(^(void) { %orig; });
    } else {
        %orig;
    }
}
%end
%hook AWEPlayInteractionUserAvatarElement
- (void)onFollowViewClicked:(id)sender {
    if ([DouXManager followConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end

%hook AWEFeedVideoButton // like feed confirmation
- (void)_onTouchUpInside {
    if ([DouXManager likeConfirmation] && [self.imageNameString isEqualToString:@"ic_like_fill_1_new"]) {
        showConfirmation(^(void) { %orig; });
    } else {
        %orig;
    }
}
%end
%hook AWECommentPanelCell // like/dislike comment confirmation
- (void)onLikeAction:(id)arg1 {
    if ([DouXManager likeCommentConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)onDislikeAction:(id)arg1 {
    if ([DouXManager dislikeCommentConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end

%hook AWETextInputController
- (NSUInteger)maxLength {
    if ([DouXManager extendedComment]) {
        return 500;
    }

    return %orig;
}
%end
%hook AWEPlayVideoPlayerController
- (void)containerDidFullyDisplayWithReason:(NSInteger)arg1 {
    if ([[[self container] parentViewController] isKindOfClass:%c(AWENewFeedTableViewController)] && [DouXManager skipRecommendations]) {
        AWENewFeedTableViewController *rootVC = [[self container] parentViewController];
        AWEAwemeModel *currentModel = [rootVC currentAweme];
        if ([currentModel isUserRecommendBigCard]) {
            [rootVC scrollToNextVideo];
        }
    }else {
        %orig;
    }
}
%end

%hook AWEPlayInteractionAuthorView
%new - (NSString *)emojiForCountryCode:(NSString *)countryCode {
    // Convert the country code to uppercase
    NSString *uppercaseCountryCode = [countryCode uppercaseString];
    
    // Ensure the country code has exactly two characters
    if (uppercaseCountryCode.length != 2) {
        return nil;
    }
    
    // Convert the country code to the regional indicator symbols
    uint32_t firstLetter = [uppercaseCountryCode characterAtIndex:0] + 0x1F1E6 - 'A';
    uint32_t secondLetter = [uppercaseCountryCode characterAtIndex:1] + 0x1F1E6 - 'A';
    
    // Create the emoji using the regional indicator symbols
    NSString *flagEmoji = [[NSString alloc] initWithBytes:&firstLetter length:4 encoding:NSUTF32LittleEndianStringEncoding];
    flagEmoji = [flagEmoji stringByAppendingString:[[NSString alloc] initWithBytes:&secondLetter length:4 encoding:NSUTF32LittleEndianStringEncoding]];
    
    return flagEmoji;
}

- (void)layoutSubviews {
    %orig;
    if ([DouXManager uploadRegion]){
        for (int i = 0; i < [[self subviews] count]; i ++){
            id j = [[self subviews] objectAtIndex:i];
            if ([j isKindOfClass:%c(UIStackView)]){
                CGRect frame = [j frame];
                frame.origin.x = 39.5; 
                [j setFrame:frame];
            }else {
                [[self viewWithTag:666] removeFromSuperview];
            }
        }
        [[self viewWithTag:666] removeFromSuperview];
        AWEFeedCellViewController* rootVC = self.yy_viewController;
        AWEAwemeModel *model = rootVC.model;
        NSString *countryID = model.region;
        UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,2,39.5,20.5)];
        NSString *countryEmoji = [self emojiForCountryCode:countryID];
        uploadLabel.text = [NSString stringWithFormat:@"%@ •",countryEmoji];
        uploadLabel.tag = 666;
        [uploadLabel setTextColor: [UIColor whiteColor]];
        [uploadLabel sizeToFit];
        [self addSubview:uploadLabel];
    }
}
%end

%hook AWELiveFeedEntranceView
- (void)switchStateWithTapped:(BOOL)arg1 {
    if (![DouXManager liveActionEnabled] || [DouXManager selectedLiveAction] == 0) {
        %orig;
    } else if ([DouXManager liveActionEnabled] && [[DouXManager selectedLiveAction] intValue] == 1) {
        UINavigationController *DouXSettings = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        [topMostController() presentViewController:DouXSettings animated:true completion:nil];
    } 
    else {
        %orig;
    }

}
%end


%hook AWEFeedViewTemplateCell
%property (nonatomic, strong) JGProgressHUD *hud;
%property(nonatomic, assign) BOOL elementsHidden;
%property (nonatomic, retain) NSString *fileextension;
%property (nonatomic, retain) UIProgressView *progressView;

- (void)configWithModel:(id)model {
    %orig;
    self.elementsHidden = false;
    if ([DouXManager downloadButton]){
        [self addDownloadButton];
    }
    if ([DouXManager hideElementButton]) {
        [self addHideElementButton];
    }
    if ([DouXManager showVaultButton]) {
        [self addVaultButton];
    }
    if ([DouXManager flexEnabled]) {
        [self addFlexButton];
    }
}
- (void)configureWithModel:(id)model {
    %orig;
    self.elementsHidden = false;
    if ([DouXManager downloadButton]){
        [self addDownloadButton];
    }
    if ([DouXManager hideElementButton]) {
        [self addHideElementButton];
    }
    if ([DouXManager showVaultButton]) {
        [self addVaultButton];
    }
    if ([DouXManager flexEnabled]) {
        [self addFlexButton];
    }
}
%new - (void)addDownloadButton {
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downloadButton setTag:998];
    [downloadButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [downloadButton addTarget:self action:@selector(downloadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    if (![self viewWithTag:998]) {
        [downloadButton setTintColor:[UIColor whiteColor]];
        [self addSubview:downloadButton];

        [NSLayoutConstraint activateConstraints:@[
            [downloadButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:90],
            [downloadButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [downloadButton.widthAnchor constraintEqualToConstant:30],
            [downloadButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}
%new - (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://tikwm.com/video/media/hdplay/%@.mp4", as]];
    self.fileextension = [rootVC.model.video.playURL bestURLtoDownloadFormat];
    if (downloadableURL) {
        UISelectionFeedbackGenerator *feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        objc_setAssociatedObject(self, kFeedbackGeneratorKey, feedbackGenerator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [rootVC.model.video.playURL bestURLtoDownload];
    self.fileextension = [rootVC.model.video.playURL bestURLtoDownloadFormat];
    if (downloadableURL) {
        UISelectionFeedbackGenerator *feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        objc_setAssociatedObject(self, kFeedbackGeneratorKey, feedbackGenerator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)downloadPhotos:(TTKPhotoAlbumDetailCellController *)rootVC photoIndex:(unsigned long)index {
    AWEPlayPhotoAlbumViewController *photoAlbumController = [rootVC valueForKey:@"_photoAlbumController"];
            NSArray <AWEPhotoAlbumPhoto *> *photos = rootVC.model.photoAlbum.photos;
            AWEPhotoAlbumPhoto *currentPhoto = [photos objectAtIndex:index];

                os_log_error(doux_log, "!!!!!! FIRING SINGLE PHOTO DOWNLOAD FOR INDEX %lu !!!!!!", index);
                os_log_info(doux_log, "Attempting to get image URL for single download.");
                NSURL *downloadableURL = [currentPhoto.originPhotoURL bestImageURLtoDownload];
                self.fileextension = [currentPhoto.originPhotoURL bestURLtoDownloadFormat];
                if (downloadableURL) {
                    os_log_info(doux_log, "Got image URL: %{public}@", downloadableURL);
                    DouXDownload *dwManager = [[DouXDownload alloc] init];
                    [dwManager downloadFileWithURL:downloadableURL];
                    [dwManager setDelegate:self];
                    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                    self.hud.textLabel.text = @"Downloading";
                     [self.hud showInView:topMostController().view];
                } else {
                    os_log_error(doux_log, "Failed to get image URL for single download. URL is nil.");
                }
            
    }

%new - (void)downloadPhotos:(TTKPhotoAlbumDetailCellController *)rootVC {
    NSString *video_description = rootVC.model.music_songName;
    AWEPlayPhotoAlbumViewController *photoAlbumController = [rootVC valueForKey:@"_photoAlbumController"];

            NSArray <AWEPhotoAlbumPhoto *> *photos = rootVC.model.photoAlbum.photos;
            NSMutableArray<NSURL *> *fileURLs = [NSMutableArray array];

            os_log_info(doux_log, "Starting 'Download All' for photos.");
            for (AWEPhotoAlbumPhoto *currentPhoto in photos) {
                NSURL *downloadableURL = [currentPhoto.originPhotoURL bestImageURLtoDownload];
                self.fileextension = [currentPhoto.originPhotoURL bestURLtoDownloadFormat];
                if (downloadableURL) {
                    os_log_info(doux_log, "Queued image URL: %{public}@", downloadableURL);
                    [fileURLs addObject:downloadableURL];
                } else {
                    os_log_error(doux_log, "Failed to get an image URL in 'Download All'.");
                }
            }

            os_log_info(doux_log, "Total images to download: %lu", (unsigned long)[fileURLs count]);
            DouXMultipleDownload *dwManager = [[DouXMultipleDownload alloc] init];
            [dwManager setDelegate:self];
            [dwManager downloadFiles:fileURLs];
            self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            self.hud.textLabel.text = @"Downloading";
            [self.hud showInView:topMostController().view];

}
%new - (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [((AWEMusicModel *)rootVC.model.music).playURL bestURLtoDownload];
    self.fileextension = @"mp3";
    if (downloadableURL) {
        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)copyMusic:(AWEAwemeBaseViewController *)rootVC {
    NSURL *downloadableURL = [((AWEMusicModel *)rootVC.model.music).playURL bestURLtoDownload];
    if (downloadableURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [downloadableURL absoluteString];
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"Could Not Copy Music." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void)copyVideo:(AWEAwemeBaseViewController *)rootVC {
    NSURL *downloadableURL = [rootVC.model.video.playURL bestURLtoDownload];
    if (downloadableURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [downloadableURL absoluteString];
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"The video dosen't have music to download." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void)copyDecription:(AWEAwemeBaseViewController *)rootVC {
    NSString *video_description = rootVC.model.music_songName;
    if (video_description) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = video_description;
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"The video dosen't have music to download." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void) downloadButtonHandler:(UIButton *)sender {
    AWEAwemeBaseViewController *rootVC = self.viewController;
    objc_setAssociatedObject(self, kCurrentModelKey, rootVC.model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rootVC isKindOfClass:%c(AWEFeedCellViewController)]) {

         UIAction *action1 = [UIAction actionWithTitle:@"Download Video"
                                             image:[UIImage systemImageNamed:@"film"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadVideo:rootVC];
    }];
        UIAction *action0 = [UIAction actionWithTitle:@"Download HD Video"
                                             image:[UIImage systemImageNamed:@"film"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadHDVideo:rootVC];
    }];
    UIAction *action2 = [UIAction actionWithTitle:@"Download Music"
                                             image:[UIImage systemImageNamed:@"music.note"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadMusic:rootVC];
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"Copy Music link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyMusic:rootVC];
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"Copy Video link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyVideo:rootVC];
    }];
    UIAction *action5 = [UIAction actionWithTitle:@"Copy Decription"
                                             image:[UIImage systemImageNamed:@"note.text"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyDecription:rootVC];
    }];
    UIMenu *downloadMenu = [UIMenu menuWithTitle:@"Downloads Menu"
                                         children:@[action1, action0,action2]];
    UIMenu *copyMenu = [UIMenu menuWithTitle:@"Copy Menu"
                                         children:@[action3, action4, action5]];
    UIMenu *mainMenu = [UIMenu menuWithTitle:@"" children:@[downloadMenu, copyMenu]];
    [sender setMenu:mainMenu];
    sender.showsMenuAsPrimaryAction = YES;
    } else if ([self.viewController isKindOfClass:%c(TTKPhotoAlbumDetailCellController)]) {
        TTKPhotoAlbumDetailCellController *rootVC = self.viewController;
        AWEPlayPhotoAlbumViewController *photoAlbumController = [rootVC valueForKey:@"_photoAlbumController"];
        NSArray <AWEPhotoAlbumPhoto *> *photos = rootVC.model.photoAlbum.photos;
        unsigned long photosCount = [photos count];
        NSMutableArray <UIAction *> *photosActions = [NSMutableArray array];
            for (int i = 0; i < photosCount; i++) {
        NSString *title = [NSString stringWithFormat:@"Download Photo %d", i+1];
        UIAction *action = [UIAction actionWithTitle:title
                                               image:[UIImage systemImageNamed:@"photo.fill"]
                                          identifier:nil
                                             handler:^(__kindof UIAction * _Nonnull action) {
                                                [self downloadPhotos:rootVC photoIndex:i];
        }];
        [photosActions addObject:action];

    }
    UIAction *allPhotosAction = [UIAction actionWithTitle:@"Download All Photos"
                                             image:[UIImage systemImageNamed:@"photo.fill"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadPhotos:rootVC];
    }];
    [photosActions addObject:allPhotosAction];
    UIAction *action2 = [UIAction actionWithTitle:@"Download Music"
                                             image:[UIImage systemImageNamed:@"music.note"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadMusic:rootVC];
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"Copy Music link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyMusic:rootVC];
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"Copy Video link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyVideo:rootVC];
    }];
    UIAction *action5 = [UIAction actionWithTitle:@"Copy Decription"
                                             image:[UIImage systemImageNamed:@"note.text"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyDecription:rootVC];
    }];
    UIMenu *PhotosMenu = [UIMenu menuWithTitle:@"Download Photos Menu"
                                         children:photosActions];
    UIMenu *downloadMenu = [UIMenu menuWithTitle:@"Downloads Menu"
                                         children:@[action2]];
    UIMenu *copyMenu = [UIMenu menuWithTitle:@"Copy Menu"
                                         children:@[action3, action4, action5]];
    UIMenu *mainMenu = [UIMenu menuWithTitle:@"" children:@[PhotosMenu, downloadMenu, copyMenu]];
    [sender setMenu:mainMenu];
    sender.showsMenuAsPrimaryAction = YES;
    }else if ([self.viewController isKindOfClass:%c(TTKPhotoAlbumFeedCellController)]) {
        TTKPhotoAlbumFeedCellController *rootVC = self.viewController;
        AWEPlayPhotoAlbumViewController *photoAlbumController = [rootVC valueForKey:@"_photoAlbumController"];
        NSArray <AWEPhotoAlbumPhoto *> *photos = rootVC.model.photoAlbum.photos;
        unsigned long photosCount = [photos count];
        NSMutableArray <UIAction *> *photosActions = [NSMutableArray array];
            for (int i = 0; i < photosCount; i++) {
        NSString *title = [NSString stringWithFormat:@"Download Photo %d", i+1];
        UIAction *action = [UIAction actionWithTitle:title
                                               image:[UIImage systemImageNamed:@"photo.fill"]
                                          identifier:nil
                                             handler:^(__kindof UIAction * _Nonnull action) {
                                                [self downloadPhotos:rootVC photoIndex:i];
        }];
        [photosActions addObject:action];

    }
        UIAction *allPhotosAction = [UIAction actionWithTitle:@"Download Photos"
                                             image:[UIImage systemImageNamed:@"photo.fill"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadPhotos:rootVC];
    }];
    [photosActions addObject:allPhotosAction];
    UIAction *action2 = [UIAction actionWithTitle:@"Download Music"
                                             image:[UIImage systemImageNamed:@"music.note"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self downloadMusic:rootVC];
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"Copy Music link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyMusic:rootVC];
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"Copy Video link"
                                             image:[UIImage systemImageNamed:@"link"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyVideo:rootVC];
    }];
    UIAction *action5 = [UIAction actionWithTitle:@"Copy Decription"
                                             image:[UIImage systemImageNamed:@"note.text"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
                                             [self copyDecription:rootVC];
    }];
    UIMenu *PhotosMenu = [UIMenu menuWithTitle:@"Download Photos Menu"
                                         children:photosActions];
    UIMenu *downloadMenu = [UIMenu menuWithTitle:@"Downloads Menu"
                                         children:@[action2]];
    UIMenu *copyMenu = [UIMenu menuWithTitle:@"Copy Menu"
                                         children:@[action3, action4, action5]];
    UIMenu *mainMenu = [UIMenu menuWithTitle:@"" children:@[PhotosMenu, downloadMenu, copyMenu]];
    [sender setMenu:mainMenu];
    sender.showsMenuAsPrimaryAction = YES;
    }
}
%new - (void)addFlexButton {
    UIButton *flexButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [flexButton setTag:1000];
    [flexButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [flexButton addTarget:self action:@selector(flexButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [flexButton setImage:[UIImage systemImageNamed:@"curlybraces.square"] forState:UIControlStateNormal];
    if (![self viewWithTag:1000]) {
        [flexButton setTintColor:[UIColor whiteColor]];
        [self addSubview:flexButton];
        [NSLayoutConstraint activateConstraints:@[
            [flexButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:130],
            [flexButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [flexButton.widthAnchor constraintEqualToConstant:30],
            [flexButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}
%new - (void)flexButtonHandler:(UIButton *)sender {
    [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
}
%new - (void)addHideElementButton {
    UIButton *hideElementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hideElementButton setTag:999];
    [hideElementButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [hideElementButton addTarget:self action:@selector(hideElementButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    if (self.elementsHidden) {
        [hideElementButton setImage:[UIImage systemImageNamed:@"eye"] forState:UIControlStateNormal];
    } else {
        [hideElementButton setImage:[UIImage systemImageNamed:@"eye.slash"] forState:UIControlStateNormal];
    }

    if (![self viewWithTag:999]) {
        [hideElementButton setTintColor:[UIColor whiteColor]];
        [self addSubview:hideElementButton];

        [NSLayoutConstraint activateConstraints:@[
            [hideElementButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:50],
            [hideElementButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [hideElementButton.widthAnchor constraintEqualToConstant:30],
            [hideElementButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}
%new - (void)hideElementButtonHandler:(UIButton *)sender {
    AWEAwemeBaseViewController *rootVC = self.viewController;
    if ([rootVC.interactionController isKindOfClass:%c(TTKFeedInteractionLegacyMainContainerElement)]) {
        TTKFeedInteractionLegacyMainContainerElement *interactionController = rootVC.interactionController;
        if (self.elementsHidden) {
            self.elementsHidden = false;
            [interactionController hideAllElements:false exceptArray:nil];
            [sender setImage:[UIImage systemImageNamed:@"eye.slash"] forState:UIControlStateNormal];
        } else {
            self.elementsHidden = true;
            [interactionController hideAllElements:true exceptArray:nil];
            [sender setImage:[UIImage systemImageNamed:@"eye"] forState:UIControlStateNormal];
        }
    }
}

%new - (void)addVaultButton {
    UIButton *vaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [vaultButton setTag:1001];
    [vaultButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [vaultButton addTarget:self action:@selector(vaultButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [vaultButton setImage:[UIImage systemImageNamed:@"lock.rectangle.stack.fill"] forState:UIControlStateNormal];
    if (![self viewWithTag:1001]) {
        [vaultButton setTintColor:[UIColor whiteColor]];
        [self addSubview:vaultButton];

        [NSLayoutConstraint activateConstraints:@[
            [vaultButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:170],
            [vaultButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [vaultButton.widthAnchor constraintEqualToConstant:30],
            [vaultButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}

%new - (void)vaultButtonHandler:(UIButton *)sender {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    VaultViewController *vaultVC = [[VaultViewController alloc] initWithCollectionViewLayout:layout];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vaultVC];
    [topMostController() presentViewController:navController animated:YES completion:nil];
}

%new - (void)downloaderProgress:(float)progress {
    self.hud.detailTextLabel.text = [DouXManager getDownloadingPersent:progress];
}
%new - (void)downloaderDidFinishDownloadingAllFiles:(NSMutableArray<NSURL *> *)downloadedFilePaths {
    os_log_info(doux_log, "'Download All' completed. Saving %lu files.", (unsigned long)[downloadedFilePaths count]);
    os_log_info(doux_log, "downloaderDidFinishDownloadingAllFiles called.");
    [self.hud dismiss];
    if ([DouXManager shareSheet]) {
        [DouXManager showSaveVC:downloadedFilePaths];
    }
    else {
        os_log_info(doux_log, "Calling saveMedia for %lu files.", (unsigned long)[downloadedFilePaths count]);
        for (NSURL *url in downloadedFilePaths) {
            AWEAwemeModel *model = objc_getAssociatedObject(self, kCurrentModelKey);
            NSString *creator = model.author.nickname;
            [DouXManager saveMedia:url withCreator:creator andType:VaultMediaItemTypePhoto];
        }
    }
}
%new - (void)downloaderDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}

%new - (void)downloader:(id)downloader didFinishDownloadingFile:(NSURL *)filePath atIndex:(NSInteger)index totalFiles:(NSInteger)total {
    os_log_info(doux_log, "Photo %ld of %ld finished downloading.", (long)index + 1, (long)total);
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
}

%new - (void)downloadProgress:(float)progress {
    UISelectionFeedbackGenerator *feedbackGenerator = objc_getAssociatedObject(self, kFeedbackGeneratorKey);
    if (feedbackGenerator) {
        [feedbackGenerator selectionChanged];
    }
    self.progressView.progress = progress;
    self.hud.detailTextLabel.text = [DouXManager getDownloadingPersent:progress];
    self.hud.tapOutsideBlock = ^(JGProgressHUD * _Nonnull HUD) {
        self.hud.textLabel.text = @"Backgrounding ✌️";
        [self.hud dismissAfterDelay:0.4];
    };
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    objc_setAssociatedObject(self, kFeedbackGeneratorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    os_log_info(doux_log, "downloadDidFinish called for single file.");
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileextension]];
    os_log_info(doux_log, "Moving file from %{public}@ to %{public}@", filePath, newFilePath);
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    [self.hud dismiss];
    NSArray *audioExtensions = @[@"mp3", @"aac", @"wav", @"m4a", @"ogg", @"flac", @"aiff", @"wma"];
    if ([DouXManager shareSheet] || [audioExtensions containsObject:self.fileextension]) {
        [DouXManager showSaveVC:@[newFilePath]];
    }
    else {
        os_log_info(doux_log, "Calling saveMedia for single file.");
        AWEAwemeModel *model = objc_getAssociatedObject(self, kCurrentModelKey);
        NSString *creator = model.author.nickname;
        VaultMediaItemType type;
        if ([self.fileextension isEqualToString:@"mp4"]) {
            type = VaultMediaItemTypeVideo;
        } else {
            type = VaultMediaItemTypePhoto;
        }
        [DouXManager saveMedia:newFilePath withCreator:creator andType:type];
    }

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    objc_setAssociatedObject(self, kFeedbackGeneratorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (error) {
        [self.hud dismiss];
    }
}
%end

%hook AWEAwemeDetailTableViewCell
%property (nonatomic, strong) JGProgressHUD *hud;
%property(nonatomic, assign) BOOL elementsHidden;
%property (nonatomic, retain) UIProgressView *progressView;
%property (nonatomic, retain) NSString *fileextension;

- (void)configWithModel:(id)model {
    %orig;
    self.elementsHidden = false;
    if ([DouXManager downloadButton]){
        [self addDownloadButton];
    }
    if ([DouXManager hideElementButton]) {
        [self addHideElementButton];
    }
    if ([DouXManager showVaultButton]) {
        [self addVaultButton];
    }
}
- (void)configureWithModel:(id)model {
    %orig;
    self.elementsHidden = false;
    if ([DouXManager downloadButton]){
        [self addDownloadButton];
    }
    if ([DouXManager hideElementButton]) {
        [self addHideElementButton];
    }
    if ([DouXManager showVaultButton]) {
        [self addVaultButton];
    }
}
%new - (void)addDownloadButton {
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downloadButton setTag:998];
    [downloadButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [downloadButton addTarget:self action:@selector(downloadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    if (![self viewWithTag:998]) {
        [downloadButton setTintColor:[UIColor whiteColor]];
        [self addSubview:downloadButton];

        [NSLayoutConstraint activateConstraints:@[
            [downloadButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:90],
            [downloadButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [downloadButton.widthAnchor constraintEqualToConstant:30],
            [downloadButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}
%new - (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://tikwm.com/video/media/hdplay/%@.mp4", as]];
    self.fileextension = [rootVC.model.video.playURL bestURLtoDownloadFormat];
    if (downloadableURL) {
        UISelectionFeedbackGenerator *feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        objc_setAssociatedObject(self, kFeedbackGeneratorKey, feedbackGenerator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [rootVC.model.video.playURL bestURLtoDownload];
        self.fileextension = [rootVC.model.video.playURL bestURLtoDownloadFormat];
    if (downloadableURL) {
        UISelectionFeedbackGenerator *feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        objc_setAssociatedObject(self, kFeedbackGeneratorKey, feedbackGenerator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC {
    NSString *as = rootVC.model.itemID;
    NSURL *downloadableURL = [((AWEMusicModel *)rootVC.model.music).playURL bestURLtoDownload];
        self.fileextension = @"mp3";
    if (downloadableURL) {
        DouXDownload *dwManager = [[DouXDownload alloc] init];
        [dwManager downloadFileWithURL:downloadableURL];
        [dwManager setDelegate:self];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.hud.textLabel.text = @"Downloading";
        [self.hud showInView:topMostController().view];
    }
}
%new - (void)copyMusic:(AWEAwemeBaseViewController *)rootVC {
    NSURL *downloadableURL = [((AWEMusicModel *)rootVC.model.music).playURL bestURLtoDownload];
    if (downloadableURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [downloadableURL absoluteString];
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"The video dosen't have music to download." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void)copyVideo:(AWEAwemeBaseViewController *)rootVC {
    NSURL *downloadableURL = [rootVC.model.video.playURL bestURLtoDownload];
    if (downloadableURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [downloadableURL absoluteString];
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"The video dosen't have music to download." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void)copyDecription:(AWEAwemeBaseViewController *)rootVC {
    NSString *video_description = rootVC.model.music_songName;
    if (video_description) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = video_description;
    } else {
        [%c(AWEUIAlertView) showAlertWithTitle:@"DouX, Hi" description:@"The video dosen't have music to download." image:nil actionButtonTitle:@"OK" cancelButtonTitle:nil actionBlock:nil cancelBlock:nil];
    }
}
%new - (void) downloadButtonHandler:(UIButton *)sender {
    AWEAwemeBaseViewController *rootVC = self.viewController;
    objc_setAssociatedObject(self, kCurrentModelKey, rootVC.model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rootVC.interactionController isKindOfClass:%c(TTKFeedInteractionLegacyMainContainerElement)]) {

     UIAction *action1 = [UIAction actionWithTitle:@"Download Video"
                                            image:[UIImage systemImageNamed:@"film"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self downloadVideo:rootVC];
    }];
    UIAction *action0 = [UIAction actionWithTitle:@"Download HD Video"
                                            image:[UIImage systemImageNamed:@"film"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self downloadHDVideo:rootVC];
    }];
    UIAction *action2 = [UIAction actionWithTitle:@"Download Music"
                                            image:[UIImage systemImageNamed:@"music.note"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self downloadMusic:rootVC];
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"Copy Music link"
                                            image:[UIImage systemImageNamed:@"link"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self copyMusic:rootVC];
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"Copy Video link"
                                            image:[UIImage systemImageNamed:@"link"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self copyVideo:rootVC];
    }];
    UIAction *action5 = [UIAction actionWithTitle:@"Copy Decription"
                                            image:[UIImage systemImageNamed:@"note.text"]
                                       identifier:nil
                                          handler:^(__kindof UIAction * _Nonnull action) {
                                            [self copyDecription:rootVC];
    }];
    UIMenu *downloadMenu = [UIMenu menuWithTitle:@"Downloads Menu"
                                        children:@[action1, action0,action2]];
    UIMenu *copyMenu = [UIMenu menuWithTitle:@"Copy Menu"
                                        children:@[action3, action4, action5]];
    UIMenu *mainMenu = [UIMenu menuWithTitle:@"" children:@[downloadMenu, copyMenu]];
    [sender setMenu:mainMenu];
    sender.showsMenuAsPrimaryAction = YES;
    }
}

%new - (void)addVaultButton {
    UIButton *vaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [vaultButton setTag:1001];
    [vaultButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [vaultButton addTarget:self action:@selector(vaultButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [vaultButton setImage:[UIImage systemImageNamed:@"lock.rectangle.stack.fill"] forState:UIControlStateNormal];
    if (![self viewWithTag:1001]) {
        [vaultButton setTintColor:[UIColor whiteColor]];
        [self addSubview:vaultButton];

        [NSLayoutConstraint activateConstraints:@[
            [vaultButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:170],
            [vaultButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [vaultButton.widthAnchor constraintEqualToConstant:30],
            [vaultButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}

%new - (void)vaultButtonHandler:(UIButton *)sender {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    VaultViewController *vaultVC = [[VaultViewController alloc] initWithCollectionViewLayout:layout];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vaultVC];
    [topMostController() presentViewController:navController animated:YES completion:nil];
}

%new - (void)addHideElementButton {
    UIButton *hideElementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hideElementButton setTag:999];
    [hideElementButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [hideElementButton addTarget:self action:@selector(hideElementButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    if (self.elementsHidden) {
        [hideElementButton setImage:[UIImage systemImageNamed:@"eye"] forState:UIControlStateNormal];
    } else {
        [hideElementButton setImage:[UIImage systemImageNamed:@"eye.slash"] forState:UIControlStateNormal];
    }

    if (![self viewWithTag:999]) {
        [hideElementButton setTintColor:[UIColor whiteColor]];
        [self addSubview:hideElementButton];

        [NSLayoutConstraint activateConstraints:@[
            [hideElementButton.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:50],
            [hideElementButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
            [hideElementButton.widthAnchor constraintEqualToConstant:30],
            [hideElementButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
}
%new - (void)hideElementButtonHandler:(UIButton *)sender {
    AWEAwemeBaseViewController *rootVC = self.viewController;
    if ([rootVC.interactionController isKindOfClass:%c(TTKFeedInteractionLegacyMainContainerElement)]) {
        TTKFeedInteractionLegacyMainContainerElement *interactionController = rootVC.interactionController;
        if (self.elementsHidden) {
            self.elementsHidden = false;
            [interactionController hideAllElements:false exceptArray:nil];
            [sender setImage:[UIImage systemImageNamed:@"eye.slash"] forState:UIControlStateNormal];
        } else {
            self.elementsHidden = true;
            [interactionController hideAllElements:true exceptArray:nil];
            [sender setImage:[UIImage systemImageNamed:@"eye"] forState:UIControlStateNormal];
        }
    }
}

%new - (void)downloadProgress:(float)progress {
    UISelectionFeedbackGenerator *feedbackGenerator = objc_getAssociatedObject(self, kFeedbackGeneratorKey);
    if (feedbackGenerator) {
        [feedbackGenerator selectionChanged];
    }
        self.hud.tapOutsideBlock = ^(JGProgressHUD * _Nonnull HUD) {
        self.hud.textLabel.text = @"Backgrounding ✌️";
        [self.hud dismissAfterDelay:0.4];
    };
    self.progressView.progress = progress;
    self.hud.detailTextLabel.text = [DouXManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    objc_setAssociatedObject(self, kFeedbackGeneratorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    os_log_info(doux_log, "downloadDidFinish called for single file.");
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileextension]];
    os_log_info(doux_log, "Moving file from %{public}@ to %{public}@", filePath, newFilePath);
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    [self.hud dismiss];
    NSArray *audioExtensions = @[@"mp3", @"aac", @"wav", @"m4a", @"ogg", @"flac", @"aiff", @"wma"];
    if ([DouXManager shareSheet] || [audioExtensions containsObject:self.fileextension]) {
        [DouXManager showSaveVC:@[newFilePath]];
    }
    else {
        os_log_info(doux_log, "Calling saveMedia for single file.");
        AWEAwemeModel *model = objc_getAssociatedObject(self, kCurrentModelKey);
        NSString *creator = model.author.nickname;
        VaultMediaItemType type;
        if ([self.fileextension isEqualToString:@"mp4"]) {
            type = VaultMediaItemTypeVideo;
        } else {
            type = VaultMediaItemTypePhoto;
        }
        [DouXManager saveMedia:newFilePath withCreator:creator andType:type];
    }

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    objc_setAssociatedObject(self, kFeedbackGeneratorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (error) {
        [self.hud dismiss];
    }
}
%end

%hook TTKStoryDetailTableViewCell
    // TODO...
%end

%hook AWEURLModel
%new - (NSString *)bestURLtoDownloadFormat {
    NSString *bestURLFormat = nil;
    for (NSString *url in self.originURLList) {
        if ([url containsString:@"video_mp4"]) {
            bestURLFormat = @"mp4";
            break;
        } else if ([url containsString:@".jpeg"]) {
            bestURLFormat = @"jpeg";
            break;
        } else if ([url containsString:@".png"]) {
            bestURLFormat = @"png";
            break;
        } else if ([url containsString:@".mp3"]) {
            bestURLFormat = @"mp3";
            break;
        } else if ([url containsString:@".m4a"]) {
            bestURLFormat = @"m4a";
            break;
        }
    }
    if (bestURLFormat == nil && self.originURLList.count > 0) {
        // A simple fallback, may not be accurate
        bestURLFormat = @"mp4";
    }

    return bestURLFormat;
}
%new - (NSURL *)bestImageURLtoDownload {
    os_log_info(doux_log, "Searching for best image URL in list: %{public}@", self.originURLList);
    for (NSString *url in self.originURLList) {
        NSString *lowerUrl = [url lowercaseString];
        if ([lowerUrl containsString:@".jpeg"] || [lowerUrl containsString:@".png"] || [lowerUrl containsString:@".heic"]) {
            os_log_info(doux_log, "Found image URL: %{public}@", url);
            return [NSURL URLWithString:url];
        }
    }
    os_log_error(doux_log, "No valid image URL was found in the list.");
    return nil; // No more fallback
}
%new - (NSURL *)bestURLtoDownload {
    for (NSString *url in self.originURLList) {
        if ([url containsString:@"video_mp4"]) {
            return [NSURL URLWithString:url];
        }
    }

    if (self.originURLList.count > 0) {
        return [NSURL URLWithString:[self.originURLList firstObject]];
    }

    return nil;
}
%end