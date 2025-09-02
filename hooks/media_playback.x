#import "TikTokHeaders.h"
#import "common.h"

%hook TTKMediaSpeedControlService
- (void)setPlaybackRate:(CGFloat)arg1 {
    NSNumber *speed = [DouXManager selectedSpeed];
    if (![DouXManager speedEnabled] || [speed isEqualToNumber:@1]) {
        return %orig;
    }
    if ([DouXManager speedEnabled]) {
        if ([DouXManager selectedSpeed]) {
            return %orig([speed floatValue]);
        }
    } else {
        return %orig;
    }
}
%end

%hook AWEPlayVideoPlayerController // auto play next video and stop looping video
- (void)playerWillLoopPlaying:(id)arg1 {
    if ([DouXManager autoPlay]) {
        if ([self.container.parentViewController isKindOfClass:%c(AWENewFeedTableViewController)]) {
            [((AWENewFeedTableViewController *)self.container.parentViewController) scrollToNextVideo];
            return;
        }
    }
    %orig;
}
- (BOOL)loop {
    if ([DouXManager stopPlay]) {
        return 0;
    }
    return %orig; 
}
- (void)setLoop:(BOOL)arg1 {
    if ([DouXManager stopPlay]) {
        %orig(0);
    }else {
        %orig;
    }
}
%end