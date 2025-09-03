#import "ViewController.h"
#import "CountryTable.h"
#import "LiveActions.h"
#import "PlaybackSpeed.h"
#import "VaultViewController.h"
#import "VaultManager.h"

@interface ViewController ()
@property (nonatomic, strong) UITableView *staticTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.title = @"DouX++ Settings";
    self.staticTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.staticTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.staticTable];
    [NSLayoutConstraint activateConstraints:@[
        [self.staticTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.staticTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.staticTable.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.staticTable.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    self.staticTable.dataSource = self;
    self.staticTable.delegate = self;
    self.staticTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(regionSelected:)
                                                 name:@"RegionSelectedNotification"
                                               object:nil];
}

- (void)regionSelected:(NSNotification *)notification {
    [self.staticTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Feed";
        case 1:
            return @"Profile";
        case 2:
            return @"Confirm";
        case 3:
            return @"Other";
        case 4:
            return @"Media Vault";
        case 5:
            return @"Region";
        case 6:
            return @"Live Button Function";
        case 7:
            return @"Playback Speed";
        case 8:
            return @"Developer";
        case 9:
            return @"Credits";
        default:
            break;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 16;
        case 1: return 4;
        case 2: return 4;
        case 3: return 10;
        case 4: return 3;
        case 5: return 2;
        case 6: return 2;
        case 7: return 2;
        case 8: return 3;
        case 9: return 2;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Hide Ads" Detail:@"Hide all ads from the app" Key:@"hide_ads"];
            case 1: return [self createSwitchCellWithTitle:@"Download Button" Detail:@"Enable download button for videos" Key:@"download_button"];
            case 2: return [self createSwitchCellWithTitle:@"Share Sheet" Detail:@"Enable sharing options in share sheet" Key:@"share_sheet"];
            case 3: return [self createSwitchCellWithTitle:@"Remove Watermark" Detail:@"Remove the TikTok watermark from videos" Key:@"remove_watermark"];
            case 4: return [self createSwitchCellWithTitle:@"Show/Hide UI Button" Detail:@"Show or hide the UI button" Key:@"remove_elements_button"];
            case 5: return [self createSwitchCellWithTitle:@"Stop Playback" Detail:@"Stop video playback automatically" Key:@"stop_play"];
            case 6: return [self createSwitchCellWithTitle:@"Auto Play Next Video" Detail:@"Automatically play the next video" Key:@"auto_play"];
            case 7: return [self createSwitchCellWithTitle:@"Show Progress Bar" Detail:@"Display progress bar on video playback" Key:@"show_porgress_bar"];
            case 8: return [self createSwitchCellWithTitle:@"Transparent Comments" Detail:@"Make comments transparent" Key:@"transparent_commnet"];
            case 9: return [self createSwitchCellWithTitle:@"Show Usernames" Detail:@"Display usernames on videos" Key:@"show_username"];
            case 10: return [self createSwitchCellWithTitle:@"Disable Sensitive Content" Detail:@"Disable sensitive content filter" Key:@"disable_unsensitive"];
            case 11: return [self createSwitchCellWithTitle:@"Disable Warnings" Detail:@"Disable TikTok warnings" Key:@"disable_warnings"];
            case 12: return [self createSwitchCellWithTitle:@"Disable Live Streaming" Detail:@"Disable live video streaming" Key:@"disable_live"];
            case 13: return [self createSwitchCellWithTitle:@"Skip Recommendations" Detail:@"Skip recommended videos" Key:@"skip_recommnedations"];
            case 14: return [self createSwitchCellWithTitle:@"Upload Region" Detail:@"Show Upload Region Flag Next to Username" Key:@"upload_region"];
            case 15: return [self createSwitchCellWithTitle:@"Block TikTok Shop" Detail:@"Block videos containing TikTok Shop products" Key:@"block_shop_videos"];
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Profile Save" Detail:@"Save profile details to clipboard" Key:@"save_profile"];
            case 1: return [self createSwitchCellWithTitle:@"Profile Copy" Detail:@"Copy profile information" Key:@"copy_profile_information"];
            case 2: return [self createSwitchCellWithTitle:@"Video Like Count" Detail:@"Show the number of likes on videos" Key:@"video_like_count"];
            case 3: return [self createSwitchCellWithTitle:@"Video Upload Date" Detail:@"Show the date videos were uploaded" Key:@"video_upload_date"];
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Like Confirmation" Detail:@"Confirm before liking a video" Key:@"like_confirm"];
            case 1: return [self createSwitchCellWithTitle:@"Like Comment Confirmation" Detail:@"Confirm before liking a comment" Key:@"like_comment_confirm"];
            case 2: return [self createSwitchCellWithTitle:@"Dislike Comment Confirmation" Detail:@"Confirm before disliking a comment" Key:@"dislike_comment_confirm"];
            case 3: return [self createSwitchCellWithTitle:@"Follow Confirmation" Detail:@"Confirm before following a user" Key:@"follow_confirm"];
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Always Open Safari" Detail:@"Always open links in Safari" Key:@"openInBrowser"];
            case 1: return [self createSwitchCellWithTitle:@"Enable Fake Changes" Detail:@"Enable fake profile changes" Key:@"en_fake"];
            case 2: return [self createTextFieldCellWithTitle:@"Follower Count" Key:@"follower_count"];
            case 3: return [self createTextFieldCellWithTitle:@"Following Count" Key:@"following_count"];
            case 4: return [self createSwitchCellWithTitle:@"Fake Verified" Detail:@"Make your account appear verified" Key:@"fake_verify"];
            case 5: return [self createSwitchCellWithTitle:@"Extended Bio" Detail:@"Extend bio section of your profile" Key:@"extended_bio"];
            case 6: return [self createSwitchCellWithTitle:@"Extended Comments" Detail:@"Extend the length of your comments" Key:@"extendedComment"];
            case 7: return [self createSwitchCellWithTitle:@"Upload HD" Detail:@"Upload videos in HD quality" Key:@"upload_hd"];
            case 8: return [self createSwitchCellWithTitle:@"App Lock" Detail:@"Lock the app with a passcode" Key:@"padlock"];
            case 9: return [self createSwitchCellWithTitle:@"Enable Flex" Detail:@"Developers Only, DON'T touch it if you don't know what you are doing." Key:@"flex_enabled"];
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            cell.textLabel.text = @"Media Vault";
            cell.detailTextLabel.text = @"View your saved media";
            cell.imageView.image = [UIImage systemImageNamed:@"folder.fill"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else if (indexPath.row == 1) {
            return [self createSwitchCellWithTitle:@"Show Vault Button" Detail:@"Show a button on the feed to open the vault" Key:@"show_vault_button"];
        } else {
            return [self createSwitchCellWithTitle:@"Encrypt Vault" Detail:@"Encrypt your media vault with a password" Key:@"vault_encryption_enabled"];
        }
    } else if (indexPath.section == 5) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Enable Region Changing" Detail:@"Enable region changing functionality" Key:@"en_region"];
            case 1: {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
                cell.textLabel.text = @"Regions";
                NSDictionary *selectedRegion = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"region"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", selectedRegion[@"area"]];
                return cell;
            }
        }
    } else if (indexPath.section == 6) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Live Button Action" Detail:@"Change The Default Live Button Action" Key:@"en_livefunc"];
            case 1: {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
                cell.textLabel.text = @"Actions";
                NSString *selectedLiveAction = [[NSUserDefaults standardUserDefaults] valueForKey:@"live_action"];
                NSArray *liveFuncTitles = @[@"Default", @"DouX++ Settings", @"Playback Speed"];
                if (selectedLiveAction != nil) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [liveFuncTitles objectAtIndex:[selectedLiveAction integerValue]]];
                }
                return cell;
            }
        }
    } else if (indexPath.section == 7) {
        switch (indexPath.row) {
            case 0: return [self createSwitchCellWithTitle:@"Playback Speed" Detail:@"Enable Presistent Playback Speed." Key:@"playback_en"];
            case 1: {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
                cell.textLabel.text = @"Speeds";
                NSString *selectedSpeed = [[NSUserDefaults standardUserDefaults] valueForKey:@"playback_speed"];
                if (selectedSpeed != nil) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x", selectedSpeed];
                }
                return cell;
            }
        }
    } else if (indexPath.section == 8) {
        switch (indexPath.row) {
            case 0: return [self createLinkCellWithTitle:@"Kunihir0" Detail:@"Github Page" Image:@"link"];
            case 1: return [self createLinkCellWithTitle:@"FBI" Detail:@"X Page" Image:@"link"];
        }
    } else if (indexPath.section == 9) {
        switch (indexPath.row) {
            case 0: return [self createLinkCellWithTitle:@"BHTikTok" Detail:@"Original Tweak" Image:@"link"];
            case 1: return [self createLinkCellWithTitle:@"BHTikTok++" Detail:@"Forked Tweak" Image:@"link"];
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4 && indexPath.row == 0) {
        VaultViewController *vaultVC = [[VaultViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vaultVC];
        [self presentViewController:navController animated:YES completion:nil];
    } else if (indexPath.section == 5 && indexPath.row == 1) {
        CountryTable *countryTable = [[CountryTable alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:countryTable];
        [self presentViewController:navController animated:YES completion:nil];
    } else if (indexPath.section == 6 && indexPath.row == 1) {
        LiveActions *liveActions = [[LiveActions alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:liveActions];
        [self presentViewController:navController animated:YES completion:nil];
    } else if (indexPath.section == 7 && indexPath.row == 1) {
        PlaybackSpeed *playbackSpeed = [[PlaybackSpeed alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:playbackSpeed];
        [self presentViewController:navController animated:YES completion:nil];
    } else if (indexPath.section == 8) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/kunihir0"] options:@{} completionHandler:nil];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://x.com/FBI"] options:@{} completionHandler:nil];
        }
    } else if (indexPath.section == 9) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/BandarHL/BHTikTok"] options:@{} completionHandler:nil];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/raulsaeed/BHTikTokPlusPlus"] options:@{} completionHandler:nil];
        }
    }
}

- (UITableViewCell *)createSwitchCellWithTitle:(NSString *)title Detail:(NSString*)detail Key:(NSString*)key {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    UISwitch *switchView = [[UISwitch alloc] init];
    cell.accessoryView = switchView;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switchView.on = [defaults boolForKey:key];
    switchView.accessibilityLabel = key;
    [switchView addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    cell.textLabel.text = title;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (UITableViewCell *)createTextFieldCellWithTitle:(NSString *)title Key:(NSString*)key {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = [NSString stringWithFormat:@"Enter %@", title];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.accessibilityLabel = key;
    textField.returnKeyType = UIReturnKeyDone;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:textField];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
        [titleLabel.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [titleLabel.widthAnchor constraintEqualToConstant:120],
        
        [textField.leadingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor constant:10],
        [textField.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
        [textField.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [textField.heightAnchor constraintEqualToConstant:30]
    ]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedText = [defaults stringForKey:key];
    if (savedText) {
        textField.text = savedText;
    }
    
    return cell;
}

- (UITableViewCell *)createLinkCellWithTitle:(NSString *)title Detail:(NSString*)detail Image:(NSString*)imageName {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor systemBlueColor];
    cell.detailTextLabel.text = detail;
    cell.imageView.image = [UIImage systemImageNamed:imageName];
    cell.detailTextLabel.textColor = [UIColor systemGrayColor];
    return cell;
}

- (void)switchToggled:(UISwitch *)sender {
    NSString *key = sender.accessibilityLabel;
    if ([key isEqualToString:@"vault_encryption_enabled"]) {
        if (sender.isOn) {
            [self promptForPasswordAndEnableEncryption:sender];
        } else {
            [self promptForPasswordAndDisableEncryption:sender];
        }
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:sender.isOn forKey:key];
        [defaults synchronize];
    }
}

- (void)promptForPasswordAndEnableEncryption:(UISwitch *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enable Encryption" message:@"Please enter a password for your vault." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Confirm Password";
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction *encryptAction = [UIAlertAction actionWithTitle:@"Encrypt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        [[VaultManager sharedManager] enableEncryptionWithPassword:passwordField.text completion:^(BOOL success) {
            if (success) {
                [self.staticTable reloadData];
            } else {
                [sender setOn:NO animated:YES];
            }
        }];
    }];
    encryptAction.enabled = NO;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sender setOn:NO animated:YES];
    }];
    
    [alert addAction:encryptAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textDidChange:(UITextField *)sender {
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    if (alert) {
        if (alert.textFields.count == 2) {
            UITextField *passwordField = alert.textFields.firstObject;
            UITextField *confirmPasswordField = alert.textFields.lastObject;
            UIAlertAction *encryptAction = alert.actions.firstObject;
            encryptAction.enabled = (passwordField.text.length > 0 && [passwordField.text isEqualToString:confirmPasswordField.text]);
        } else {
            UITextField *passwordField = alert.textFields.firstObject;
            UIAlertAction *okAction = alert.actions.firstObject;
            okAction.enabled = (passwordField.text.length > 0);
        }
    }
}

- (void)promptForPasswordAndDisableEncryption:(UISwitch *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Disable Encryption" message:@"Please enter your vault password." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        [[VaultManager sharedManager] disableEncryptionWithPassword:passwordField.text completion:^(BOOL success) {
            if (success) {
                [self.staticTable reloadData];
            } else {
                [sender setOn:YES animated:YES];
            }
        }];
    }];
    okAction.enabled = NO;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sender setOn:YES animated:YES];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *key = textField.accessibilityLabel;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:textField.text forKey:key];
    [defaults synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end