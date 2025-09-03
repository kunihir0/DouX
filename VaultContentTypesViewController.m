#import "VaultContentTypesViewController.h"
#import "VaultItemsViewController.h"

@interface VaultContentTypesViewController ()
@property (nonatomic, strong) NSArray<VaultMediaItem *> *items;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<VaultMediaItem *> *> *groupedItems;
@property (nonatomic, strong) NSArray<NSNumber *> *sortedContentTypes;
@end

@implementation VaultContentTypesViewController

- (instancetype)initWithItems:(NSArray<VaultMediaItem *> *)items andUsername:(NSString *)username {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.items = items;
        self.username = username;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.username;
    
    [self groupItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self groupItems];
}

- (void)groupItems {
    NSMutableDictionary<NSNumber *, NSMutableArray<VaultMediaItem *> *> *grouped = [NSMutableDictionary dictionary];
    for (VaultMediaItem *item in self.items) {
        NSNumber *contentType = @(item.contentType);
        NSMutableArray<VaultMediaItem *> *typeItems = grouped[contentType];
        if (!typeItems) {
            typeItems = [NSMutableArray array];
            grouped[contentType] = typeItems;
        }
        [typeItems addObject:item];
    }
    self.groupedItems = grouped;
    self.sortedContentTypes = [[self.groupedItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedContentTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSNumber *contentTypeNumber = self.sortedContentTypes[indexPath.row];
    VaultMediaItemType contentType = [contentTypeNumber unsignedIntegerValue];
    
    switch (contentType) {
        case VaultMediaItemTypePhoto:
            cell.textLabel.text = @"Photos";
            break;
        case VaultMediaItemTypeVideo:
            cell.textLabel.text = @"Videos";
            break;
        case VaultMediaItemTypeAudio:
            cell.textLabel.text = @"Audio";
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *contentTypeNumber = self.sortedContentTypes[indexPath.row];
    NSArray<VaultMediaItem *> *items = self.groupedItems[contentTypeNumber];
    
    VaultItemsViewController *itemsVC = [[VaultItemsViewController alloc] initWithItems:items];
    [self.navigationController pushViewController:itemsVC animated:YES];
}

@end