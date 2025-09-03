#import "VaultStatsViewController.h"
#import "VaultManager.h"
#import "VaultFileViewerViewController.h"

@interface VaultStatsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *barChartView;
@property (nonatomic, strong) UILabel *totalSizeLabel;
@property (nonatomic, strong) UILabel *videoSizeLabel;
@property (nonatomic, strong) UILabel *photoSizeLabel;
@property (nonatomic, strong) UILabel *audioSizeLabel;
@property (nonatomic, strong) UILabel *vaultPathLabel;
@property (nonatomic, strong) UIView *encryptionStatusView;
@property (nonatomic, strong) UITableView *filesTableView;
@property (nonatomic, strong) NSArray<NSString *> *datFiles;

@end

@implementation VaultStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Vault Stats";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupViews];
    [self updateStats];
    [self findDatFiles];
}

- (void)setupViews {
    self.barChartView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 200)];
    [self.view addSubview:self.barChartView];
    
    self.totalSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.view.bounds.size.width - 40, 20)];
    [self.view addSubview:self.totalSizeLabel];
    
    self.videoSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 350, self.view.bounds.size.width - 40, 20)];
    [self.view addSubview:self.videoSizeLabel];
    
    self.photoSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, self.view.bounds.size.width - 40, 20)];
    [self.view addSubview:self.photoSizeLabel];
    
    self.audioSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 410, self.view.bounds.size.width - 40, 20)];
    [self.view addSubview:self.audioSizeLabel];
    
    self.vaultPathLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, self.view.bounds.size.width - 40, 20)];
    [self.view addSubview:self.vaultPathLabel];
    
    self.encryptionStatusView = [[UIView alloc] initWithFrame:CGRectMake(20, 470, 20, 20)];
    self.encryptionStatusView.layer.cornerRadius = 10;
    [self.view addSubview:self.encryptionStatusView];
    
    self.filesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 500, self.view.bounds.size.width, self.view.bounds.size.height - 500) style:UITableViewStyleGrouped];
    self.filesTableView.dataSource = self;
    self.filesTableView.delegate = self;
    [self.view addSubview:self.filesTableView];
}

- (void)updateStats {
    NSArray<VaultMediaItem *> *items = [[VaultManager sharedManager] allItems];
    
    long long totalSize = 0;
    long long videoSize = 0;
    long long photoSize = 0;
    long long audioSize = 0;
    
    for (VaultMediaItem *item in items) {
        long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:item.filePath error:nil] fileSize];
        totalSize += fileSize;
        
        switch (item.contentType) {
            case VaultMediaItemTypeVideo:
                videoSize += fileSize;
                break;
            case VaultMediaItemTypePhoto:
                photoSize += fileSize;
                break;
            case VaultMediaItemTypeAudio:
                audioSize += fileSize;
                break;
        }
    }
    
    self.totalSizeLabel.text = [NSString stringWithFormat:@"Total Size: %@", [NSByteCountFormatter stringFromByteCount:totalSize countStyle:NSByteCountFormatterCountStyleFile]];
    self.videoSizeLabel.text = [NSString stringWithFormat:@"Video Size: %@", [NSByteCountFormatter stringFromByteCount:videoSize countStyle:NSByteCountFormatterCountStyleFile]];
    self.photoSizeLabel.text = [NSString stringWithFormat:@"Photo Size: %@", [NSByteCountFormatter stringFromByteCount:photoSize countStyle:NSByteCountFormatterCountStyleFile]];
    self.audioSizeLabel.text = [NSString stringWithFormat:@"Audio Size: %@", [NSByteCountFormatter stringFromByteCount:audioSize countStyle:NSByteCountFormatterCountStyleFile]];
    
    self.vaultPathLabel.text = [NSString stringWithFormat:@"Vault Path: %@", [[VaultManager sharedManager] vaultPath]];
    
    if ([[VaultManager sharedManager] encryptionEnabled]) {
        self.encryptionStatusView.backgroundColor = [UIColor greenColor];
    } else {
        self.encryptionStatusView.backgroundColor = [UIColor redColor];
    }
    
    [self drawBarChartWithVideoSize:videoSize photoSize:photoSize audioSize:audioSize totalSize:totalSize];
}

- (void)drawBarChartWithVideoSize:(long long)videoSize photoSize:(long long)photoSize audioSize:(long long)audioSize totalSize:(long long)totalSize {
    for (UIView *subview in self.barChartView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (totalSize == 0) {
        return;
    }
    
    CGFloat videoHeight = (CGFloat)videoSize / totalSize * 200;
    CGFloat photoHeight = (CGFloat)photoSize / totalSize * 200;
    CGFloat audioHeight = (CGFloat)audioSize / totalSize * 200;
    
    UIView *videoBar = [[UIView alloc] initWithFrame:CGRectMake(0, 200 - videoHeight, 50, videoHeight)];
    videoBar.backgroundColor = [UIColor blueColor];
    [self.barChartView addSubview:videoBar];
    
    UIView *photoBar = [[UIView alloc] initWithFrame:CGRectMake(70, 200 - photoHeight, 50, photoHeight)];
    photoBar.backgroundColor = [UIColor greenColor];
    [self.barChartView addSubview:photoBar];
    
    UIView *audioBar = [[UIView alloc] initWithFrame:CGRectMake(140, 200 - audioHeight, 50, audioHeight)];
    audioBar.backgroundColor = [UIColor orangeColor];
    [self.barChartView addSubview:audioBar];
}

- (void)findDatFiles {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH '.dat'"];
    self.datFiles = [allFiles filteredArrayUsingPredicate:predicate];
    
    [self.filesTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *fileName = self.datFiles[indexPath.row];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    cell.detailTextLabel.text = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id unarchivedObject = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:nil];
    
    if (unarchivedObject) {
        cell.imageView.image = [UIImage systemImageNamed:@"lock.open.fill"];
    } else {
        cell.imageView.image = [UIImage systemImageNamed:@"lock.fill"];
    }
    
    if ([filePath isEqualToString:[[VaultManager sharedManager] vaultPath]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Loaded: %@", fileName];
        cell.backgroundColor = [UIColor systemGreenColor];
    } else {
        cell.textLabel.text = fileName;
        cell.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = self.datFiles[indexPath.row];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];

    if ([filePath isEqualToString:[[VaultManager sharedManager] vaultPath]]) {
        return nil;
    }

    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Vault File" message:[NSString stringWithFormat:@"Are you sure you want to delete %@?", fileName] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [self findDatFiles];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        completionHandler(YES);
    }];

    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

@end