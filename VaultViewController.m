#import "VaultViewController.h"
#import "VaultManager.h"
#import "VaultContentTypesViewController.h"
#import "VaultStatsViewController.h"

@interface VaultViewController ()
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<VaultMediaItem *> *> *groupedItems;
@property (nonatomic, strong) NSArray<NSString *> *sortedUsernames;
@end

@implementation VaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Media Vault";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stats" style:UIBarButtonItemStylePlain target:self action:@selector(showStats)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[VaultManager sharedManager] encryptionEnabled] && ![[VaultManager sharedManager] isUnlocked]) {
        [self promptForPassword];
    } else {
        [self loadData];
        [self showLegacyVaultAlertIfNeeded];
    }
}

- (void)promptForPassword {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Vault Locked" message:@"Please enter your password to unlock the vault." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        if ([[VaultManager sharedManager] unlockWithPassword:passwordField.text]) {
            [self loadData];
            [self showLegacyVaultAlertIfNeeded];
        } else {
            [self shakeTextField:passwordField];
            alert.message = @"Incorrect Password. Please try again.";
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shakeTextField:(UITextField *)textField {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(textField.center.x - 5, textField.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(textField.center.x + 5, textField.center.y)]];
    [textField.layer addAnimation:shake forKey:@"position"];
}

- (void)loadData {
    self.groupedItems = [[VaultManager sharedManager] groupedItems];
    self.sortedUsernames = [[self.groupedItems allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.tableView reloadData];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showStats {
    VaultStatsViewController *statsVC = [[VaultStatsViewController alloc] init];
    [self.navigationController pushViewController:statsVC animated:YES];
}

- (void)showLegacyVaultAlertIfNeeded {
    if ([[VaultManager sharedManager] isLegacy]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Legacy Vault Found" message:@"We found an old vault file. Do you want to save the content to your photo library or delete it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save All to Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[VaultManager sharedManager] saveLegacyItemsToPhotosWithCompletion:^(BOOL success) {
                if (success) {
                    // Optional: Show a success message
                }
            }];
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[VaultManager sharedManager] deleteLegacyVault];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:saveAction];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedUsernames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *username = self.sortedUsernames[indexPath.row];
    cell.textLabel.text = username;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *username = self.sortedUsernames[indexPath.row];
    NSArray<VaultMediaItem *> *items = self.groupedItems[username];
    
    VaultContentTypesViewController *contentTypesVC = [[VaultContentTypesViewController alloc] initWithItems:items andUsername:username];
    [self.navigationController pushViewController:contentTypesVC animated:YES];
}

@end