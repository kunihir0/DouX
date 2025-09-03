#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray<VaultMediaItem *> *items;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation PhotoViewController

- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items atIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _items = items;
        _currentIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    [self.view addSubview:self.scrollView];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    
    [self loadImage];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)loadImage {
    if (self.currentIndex < self.items.count) {
        VaultMediaItem *item = self.items[self.currentIndex];
        self.imageView.image = [UIImage imageWithContentsOfFile:item.filePath];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.currentIndex + 1 < self.items.count) {
            self.currentIndex++;
            [self transitionToImage:1];
        }
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.currentIndex > 0) {
            self.currentIndex--;
            [self transitionToImage:-1];
        }
    }
}

- (void)transitionToImage:(NSInteger)direction {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = (direction == 1) ? kCATransitionFromRight : kCATransitionFromLeft;
    [self.imageView.layer addAnimation:transition forKey:nil];
    [self loadImage];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
