#import "VaultFileViewerViewController.h"

@interface VaultFileViewerViewController ()
@property (nonatomic, strong) NSArray<id> *items;
@end

@implementation VaultFileViewerViewController

- (instancetype)initWithItems:(NSArray<id> *)items {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Vault File Viewer";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    id item = self.items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

@end
