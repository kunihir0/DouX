#import "SecurityViewController.h"
#import "VaultViewController.h"

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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    VaultViewController *vaultVC = [[VaultViewController alloc] initWithCollectionViewLayout:layout];
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

@end
