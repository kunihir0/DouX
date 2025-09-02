#import "TikTokHeaders.h"

%hook ACCCreationPublishAction
- (BOOL)is_open_hd {
    if ([DouXManager uploadHD]) {
        return 1;
    }
    return %orig;
}
- (void)setIs_open_hd:(BOOL)arg1 {
    if ([DouXManager uploadHD]) {
        %orig(1);
    }
    else {
        return %orig;
    }
}
- (BOOL)is_have_hd {
    if ([DouXManager uploadHD]) {
        return 1;
    }
    return %orig;
}
- (void)setIs_have_hd:(BOOL)arg1 {
    if ([DouXManager uploadHD]) {
        %orig(1);
    }
    else {
        return %orig;
    }
}

%end