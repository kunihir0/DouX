#import "VaultItemsViewController.h"
#import "VaultMediaItem.h"
#import "VaultManager.h"
#import "PhotoViewController.h"
#import "FilterViewController.h"
#import <AVKit/AVKit.h>
#import <CommonCrypto/CommonCrypto.h>

@interface VaultItemsViewController () <UIDocumentPickerDelegate>
@property (nonatomic, strong) NSMutableArray<VaultMediaItem *> *items;
@property (nonatomic, strong) NSDictionary *activeFilters;
@property (nonatomic, strong) NSMutableArray<VaultMediaItem *> *selectedItems;
@end

@implementation VaultItemsViewController

- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.items = [items mutableCopy];
        self.selectedItems = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Vault";
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(selectButtonTapped:)];
    
    [self loadItems];
}

- (void)loadItems {
    // This will be initialized from the previous view controller
    [self.collectionView reloadData];
}

- (void)selectButtonTapped:(id)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportButtonTapped:)];
}

- (void)cancelButtonTapped:(id)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(selectButtonTapped:)];
    self.navigationItem.leftBarButtonItem = nil;
    [self.selectedItems removeAllObjects];
    [self.collectionView reloadData];
}

- (void)exportButtonTapped:(id)sender {
    [[VaultManager sharedManager] exportItemsToPhotoLibrary:self.selectedItems completion:^(BOOL success) {
        if (success) {
            [self.items removeObjectsInArray:self.selectedItems];
            [self.selectedItems removeAllObjects];
            [self.collectionView reloadData];
            
            if (self.items.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    VaultMediaItem *item = self.items[indexPath.item];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    if (item.contentType == VaultMediaItemTypePhoto) {
        NSData *data = [NSData dataWithContentsOfFile:item.filePath];
        if ([[VaultManager sharedManager] encryptionEnabled]) {
            data = [[VaultManager sharedManager] crypt:data operation:kCCDecrypt];
        }
        imageView.image = [UIImage imageWithData:data];
    } else if (item.contentType == VaultMediaItemTypeVideo) {
        [self generateThumbnailForItem:item completion:^(UIImage *thumbnail) {
            imageView.image = thumbnail;
        }];
    } else if (item.contentType == VaultMediaItemTypeAudio) {
        imageView.image = [UIImage systemImageNamed:@"music.note"];
    }
    
    if ([self.selectedItems containsObject:item]) {
        cell.layer.borderColor = [UIColor blueColor].CGColor;
        cell.layer.borderWidth = 2.0;
    } else {
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.layer.borderWidth = 0.0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VaultMediaItem *item = self.items[indexPath.item];
    
    if (self.navigationItem.leftBarButtonItem) { // If in selection mode
        if ([self.selectedItems containsObject:item]) {
            [self.selectedItems removeObject:item];
        } else {
            [self.selectedItems addObject:item];
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        NSData *data = [NSData dataWithContentsOfFile:item.filePath];
        if ([[VaultManager sharedManager] encryptionEnabled]) {
            data = [[VaultManager sharedManager] crypt:data operation:kCCDecrypt];
        }
        
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:item.filePath.lastPathComponent];
        [data writeToFile:tempPath atomically:YES];
        NSURL *tempURL = [NSURL fileURLWithPath:tempPath];
        
        if (item.contentType == VaultMediaItemTypePhoto) {
            PhotoViewController *photoVC = [[PhotoViewController alloc] initWithItems:self.items atIndex:indexPath.item];
            [self.navigationController pushViewController:photoVC animated:YES];
        } else if (item.contentType == VaultMediaItemTypeVideo) {
            AVPlayer *player = [AVPlayer playerWithURL:tempURL];
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            playerViewController.player = player;
            [self presentViewController:playerViewController animated:YES completion:^{
                [playerViewController.player play];
            }];
        } else if (item.contentType == VaultMediaItemTypeAudio) {
            AVPlayer *player = [AVPlayer playerWithURL:tempURL];
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            playerViewController.player = player;
            [self presentViewController:playerViewController animated:YES completion:^{
                [playerViewController.player play];
            }];
        }
    }
}

- (void)generateThumbnailForItem:(VaultMediaItem *)item completion:(void (^)(UIImage *thumbnail))completion {
    if (!completion) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:item.filePath];
        if ([[VaultManager sharedManager] encryptionEnabled]) {
            data = [[VaultManager sharedManager] crypt:data operation:kCCDecrypt];
        }
        
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:item.filePath.lastPathComponent];
        [data writeToFile:tempPath atomically:YES];
        NSURL *tempURL = [NSURL fileURLWithPath:tempPath];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:tempURL options:nil];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        
        CMTime time = CMTimeMake(1, 1);
        
        NSError *error = nil;
        CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(thumbnail);
        });
    });
}

@end