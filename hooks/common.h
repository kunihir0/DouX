#import <os/log.h>

@interface AWEFeedViewTemplateCell (DouX)
- (void)addVaultButton;
- (void)vaultButtonHandler:(UIButton *)sender;
@end

@interface AWEAwemeDetailTableViewCell (DouX)
- (void)addVaultButton;
- (void)vaultButtonHandler:(UIButton *)sender;
@end

extern os_log_t doux_log;
extern const void *kFeedbackGeneratorKey;
extern const void *kCurrentModelKey;
extern NSArray *jailbreakPaths;

void showConfirmation(void (^okHandler)(void));