#import <os/log.h>

@interface AWEFeedViewTemplateCell (BHTikTok)
- (void)addVaultButton;
- (void)vaultButtonHandler:(UIButton *)sender;
@end

@interface AWEAwemeDetailTableViewCell (BHTikTok)
- (void)addVaultButton;
- (void)vaultButtonHandler:(UIButton *)sender;
@end

extern os_log_t bhtiktok_log;
extern const void *kFeedbackGeneratorKey;
extern const void *kCurrentModelKey;
extern NSArray *jailbreakPaths;

void showConfirmation(void (^okHandler)(void));