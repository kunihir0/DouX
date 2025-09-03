#import "TikTokHeaders.h"
#import "Settings/ViewController.h"
#import "common.h"

%hook TTKSettingsBaseCellPlugin
- (void)didSelectItemAtIndex:(NSInteger)index {
    if ([self.itemModel.identifier isEqualToString:@"doux_settings"]) {
        UINavigationController *DouXSettings = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        [topMostController() presentViewController:DouXSettings animated:true completion:nil];
    } else {
        return %orig;
    }
}
%end

%hook AWESettingsNormalSectionViewModel
- (void)viewDidLoad {
    %orig;
    if ([self.sectionIdentifier isEqualToString:@"account"]) {
        TTKSettingsBaseCellPlugin *DouXSettingsPluginCell = [[%c(TTKSettingsBaseCellPlugin) alloc] initWithPluginContext:self.context];

        AWESettingItemModel *DouXSettingsItemModel = [[%c(AWESettingItemModel) alloc] initWithIdentifier:@"doux_settings"];
        [DouXSettingsItemModel setTitle:@"DouX settings"];
        [DouXSettingsItemModel setDetail:@"DouX settings"];
        [DouXSettingsItemModel setIconImage:[UIImage systemImageNamed:@"gear"]];
        [DouXSettingsItemModel setType:99];

        [DouXSettingsPluginCell setItemModel:DouXSettingsItemModel];

        [self insertModel:DouXSettingsPluginCell atIndex:0 animated:true];
    }
}
%end