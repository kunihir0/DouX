#import "SecurityViewController.h"
#import "VaultViewController.h"
#import "VaultManager.h"

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    
    UIButton *authenticateButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 200, 60)];
    [authenticateButton setTitle:@"Authenticate" forState:UIControlStateNormal];
    authenticateButton.center = self.view.center;
    [authenticateButton addTarget:self action:@selector(authenticateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authenticateButton];

    UIButton *vaultButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 200, 60)];
    [vaultButton setTitle:@"Vault" forState:UIControlStateNormal];
    vaultButton.center = CGPointMake(self.view.center.x, self.view.center.y + 80);
    [vaultButton addTarget:self action:@selector(vaultButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vaultButton];
    
    [self authenticate];
}

- (void)vaultButtonTapped:(id)sender {
    VaultViewController *vaultVC = [[VaultViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vaultVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)authenticateButtonTapped:(id)sender {
    [self authenticate];
}

- (void)authenticate {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        NSString *reason = @"Identify yourself!";
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reason reply:^(BOOL success, NSError *authenticationError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    // error
                }
            });
        }];
    } else {
        // no biometry
    }
}

- (void)enableEncryption {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enable Encryption" message:@"Please enter a password for your vault." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        NSString *password = passwordField.text;
        
        if (password.length > 0) {
            [self confirmPassword:password];
        } else {
            // show error
        }
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmPassword:(NSString *)password {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Password" message:@"Please enter your password again." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        NSString *confirmedPassword = passwordField.text;
        
        if ([password isEqualToString:confirmedPassword]) {
            [[VaultManager sharedManager] enableEncryptionWithPassword:password completion:^(BOOL success) {
                if (success) {
                    // show success
                } else {
                    // show error
                }
            }];
        } else {
            // show error
        }
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)disableEncryption {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Disable Encryption" message:@"Please enter your password to disable vault encryption." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *passwordField = alert.textFields.firstObject;
        NSString *password = passwordField.text;
        
        if (password.length > 0) {
            [[VaultManager sharedManager] disableEncryptionWithPassword:password completion:^(BOOL success) {
                if (success) {
                    // show success
                } else {
                    // show error
                }
            }];
        } else {
            // show error
        }
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end