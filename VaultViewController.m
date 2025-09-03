#import "VaultViewController.h"
#import "VaultManager.h"
#import "VaultMediaItem.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoViewController.h"
#import "FilterViewController.h"
#import <Photos/Photos.h>

@interface VaultViewController () <UICollectionViewDelegateFlowLayout, FilterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray<VaultMediaItem *> *items;
@property (nonatomic, strong) NSDictionary *activeFilters;
@property (nonatomic, assign) BOOL isSelectionMode;
@property (nonatomic, strong) CAGradientLayer *rainbowLayer;
@property (nonatomic, assign) BOOL initialSelectionState;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation VaultViewController

static NSString * const reuseIdentifier = @"VaultCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Vault";
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    CGFloat size = (self.view.frame.size.width - layout.minimumInteritemSpacing * 3) / 4;
    layout.itemSize = CGSizeMake(size, size);
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];

    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportButtonTapped:)];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTapped:)];
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, exportButton, filterButton];

    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.collectionView addGestureRecognizer:self.longPressGesture];
    
    [self loadItems];
}

- (void)loadItems {
    NSArray<VaultMediaItem *> *allItems = [[VaultManager sharedManager] allItems];
    
    if (self.activeFilters) {
        NSMutableArray *predicates = [NSMutableArray array];
        
        NSNumber *showFavorites = self.activeFilters[@"showFavorites"];
        if (showFavorites && [showFavorites boolValue]) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"isFavorite == YES"]];
        }
        
        NSNumber *contentType = self.activeFilters[@"contentType"];
        if (contentType && [contentType integerValue] != 0) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"contentType == %d", ([contentType integerValue] == 1) ? VaultMediaItemTypePhoto : VaultMediaItemTypeVideo]];
        }
        
        NSArray *creators = self.activeFilters[@"creators"];
        if (creators && creators.count > 0) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"creatorUsername IN %@", creators]];
        }
        
        if (predicates.count > 0) {
            NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
            self.items = [allItems filteredArrayUsingPredicate:compoundPredicate];
        } else {
            self.items = allItems;
        }
    } else {
        self.items = allItems;
    }
    
    [self.collectionView reloadData];
}

- (void)done {
    if (self.isSelectionMode) {
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            VaultMediaItem *item = self.items[indexPath.item];
            [self exportItem:item];
        }
        [self cancelSelectionMode];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)filterButtonTapped:(id)sender {
    FilterViewController *filterVC = [[FilterViewController alloc] init];
    filterVC.delegate = self;
    filterVC.selectedFilters = self.activeFilters;
    
    NSMutableSet *creatorSet = [NSMutableSet set];
    for (VaultMediaItem *item in [[VaultManager sharedManager] allItems]) {
        if (item.creatorUsername) {
            [creatorSet addObject:item.creatorUsername];
        }
    }
    filterVC.allCreators = [creatorSet allObjects];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:filterVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didApplyFilters:(NSDictionary *)filters {
    self.activeFilters = filters;
    [self loadItems];
}

- (void)exportButtonTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Export" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"Export Selected" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.isSelectionMode = YES;
        self.collectionView.allowsMultipleSelection = YES;
        self.navigationItem.rightBarButtonItems[0].title = @"Save";
        [self addRainbowToButton:self.navigationItem.rightBarButtonItems[0]];
        self.navigationItem.rightBarButtonItems[1].enabled = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectionMode)];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Export All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (VaultMediaItem *item in self.items) {
            [self exportItem:item];
        }
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelSelectionMode {
    self.isSelectionMode = NO;
    self.collectionView.allowsMultipleSelection = NO;
    [self.collectionView reloadData];
    
    self.navigationItem.rightBarButtonItems[0].title = @"Done";
    [self removeRainbowFromButton:self.navigationItem.rightBarButtonItems[0]];
    self.navigationItem.rightBarButtonItems[1].enabled = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTapped:)];
}

- (void)exportItem:(VaultMediaItem *)item {
    [self getOrCreateAlbumWithTitle:@"plusTikTok" completion:^(PHAssetCollection *album) {
        if (album) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *changeRequest;
                if (item.contentType == VaultMediaItemTypePhoto) {
                    changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:item.filePath]];
                } else {
                    changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:item.filePath]];
                }
                PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
                [albumChangeRequest addAssets:@[changeRequest.placeholderForCreatedAsset]];
            } completionHandler:nil];
        }
    }];
}

- (void)getOrCreateAlbumWithTitle:(NSString *)title completion:(void (^)(PHAssetCollection *))completion {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    if (fetchResult.firstObject) {
        completion(fetchResult.firstObject);
    } else {
        __block PHObjectPlaceholder *placeholder;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
            placeholder = changeRequest.placeholderForCreatedAssetCollection;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil];
                completion(result.firstObject);
            } else {
                completion(nil);
            }
        }];
    }
}

- (void)addRainbowToButton:(UIBarButtonItem *)button {
    UIView *view = [button valueForKey:@"view"];
    UILabel *label = [view.subviews firstObject];

    self.rainbowLayer = [CAGradientLayer layer];
    self.rainbowLayer.frame = label.bounds;
    self.rainbowLayer.colors = @[
        (id)[UIColor redColor].CGColor,
        (id)[UIColor orangeColor].CGColor,
        (id)[UIColor yellowColor].CGColor,
        (id)[UIColor greenColor].CGColor,
        (id)[UIColor blueColor].CGColor,
        (id)[UIColor purpleColor].CGColor
    ];
    self.rainbowLayer.startPoint = CGPointMake(0.0, 0.5);
    self.rainbowLayer.endPoint = CGPointMake(1.0, 0.5);

    label.layer.mask = self.rainbowLayer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.fromValue = self.rainbowLayer.colors;
    NSMutableArray *toColors = [self.rainbowLayer.colors mutableCopy];
    [toColors addObject:[toColors firstObject]];
    [toColors removeObjectAtIndex:0];
    animation.toValue = toColors;
    animation.duration = 1.0;
    animation.repeatCount = HUGE_VALF;
    [self.rainbowLayer addAnimation:animation forKey:@"rainbow"];
}

- (void)removeRainbowFromButton:(UIBarButtonItem *)button {
    UIView *view = [button valueForKey:@"view"];
    UILabel *label = [view.subviews firstObject];
    [self.rainbowLayer removeAllAnimations];
    label.layer.mask = nil;
    self.rainbowLayer = nil;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    VaultMediaItem *item = self.items[indexPath.item];
    
    // Clear previous content
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    if (item.contentType == VaultMediaItemTypePhoto) {
        imageView.image = [UIImage imageWithContentsOfFile:item.filePath];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *thumbnail = [self generateThumbnailForVideoAtURL:[NSURL fileURLWithPath:item.filePath]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = thumbnail;
            });
        });
    }
    
    [cell.contentView addSubview:imageView];

    if (item.isFavorite) {
        UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"star.fill"]];
        starView.frame = CGRectMake(cell.contentView.bounds.size.width - 24, 4, 20, 20);
        starView.tintColor = [UIColor yellowColor];
        [cell.contentView addSubview:starView];
    }

    if (self.isSelectionMode) {
        UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        checkmarkView.frame = CGRectMake(cell.contentView.bounds.size.width - 24, cell.contentView.bounds.size.height - 24, 20, 20);
        checkmarkView.tintColor = [UIColor whiteColor];
        checkmarkView.hidden = ![self.collectionView.indexPathsForSelectedItems containsObject:indexPath];
        checkmarkView.tag = 100;
        [cell.contentView addSubview:checkmarkView];
    }

    if ([self.collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        cell.backgroundColor = [UIColor systemBlueColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

- (UIImage *)generateThumbnailForVideoAtURL:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 60);
    NSError *error = nil;
    CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VaultMediaItem *item = self.items[indexPath.item];
    if (self.isSelectionMode) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *checkmarkView = [cell.contentView viewWithTag:100];
        if ([self.collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            cell.backgroundColor = [UIColor clearColor];
            checkmarkView.hidden = YES;
        } else {
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            cell.backgroundColor = [UIColor systemBlueColor];
            checkmarkView.hidden = NO;
        }
    } else {
        if (item.contentType == VaultMediaItemTypePhoto) {
            PhotoViewController *photoVC = [[PhotoViewController alloc] initWithItems:self.items atIndex:indexPath.item];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoVC];
            navController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navController animated:YES completion:nil];
        } else {
            // TODO: Implement video player
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (self.isSelectionMode) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint point = [gestureRecognizer locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath) {
                self.initialSelectionState = ![self.collectionView.indexPathsForSelectedItems containsObject:indexPath];
                self.lastSelectedIndexPath = indexPath;
                [self updateSelectionForCellAtIndexPath:indexPath];
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint point = [gestureRecognizer locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath && ![indexPath isEqual:self.lastSelectedIndexPath]) {
                [self updateSelectionForCellAtIndexPath:indexPath];
                self.lastSelectedIndexPath = indexPath;
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            self.lastSelectedIndexPath = nil;
        }
    } else {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint p = [gestureRecognizer locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
            
            if (indexPath == nil){
                NSLog(@"couldn't find index path");
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                VaultMediaItem *item = self.items[indexPath.item];

                NSString *favoriteTitle = item.isFavorite ? @"Unfavorite" : @"Favorite";
                [alert addAction:[UIAlertAction actionWithTitle:favoriteTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    item.isFavorite = !item.isFavorite;
                    [[VaultManager sharedManager] saveVaultItems];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }]];

                [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[VaultManager sharedManager] deleteVaultItem:item];
                    [self loadItems];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

- (void)updateSelectionForCellAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *checkmarkView = [cell.contentView viewWithTag:100];

    if (self.initialSelectionState) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.backgroundColor = [UIColor systemBlueColor];
        checkmarkView.hidden = NO;
    } else {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        cell.backgroundColor = [UIColor clearColor];
        checkmarkView.hidden = YES;
    }
}

@end