#import "ConsoleViewController.h"
#import "BHLogger.h"
#import <objc/runtime.h>
#import "LogDetailViewController.h"

@interface ConsoleViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *logs;
@property (nonatomic, strong) NSArray<NSString *> *sortedSections;

@end

@implementation ConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Console";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.logs = [NSMutableDictionary dictionary];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *copyButton = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyLogs)];
    self.navigationItem.rightBarButtonItem = copyButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLogs) name:BHLoggerDidAddLogNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLogs];
}

- (void)updateLogs {
    [self.logs removeAllObjects];
    NSArray *allLogs = [BHLogger allLogs];
    for (NSString *log in allLogs) {
        NSString *section = [self sectionForLog:log];
        if (!self.logs[section]) {
            self.logs[section] = [NSMutableArray array];
        }
        [self.logs[section] addObject:log];
    }
    self.sortedSections = [[self.logs allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
}

- (NSString *)sectionForLog:(NSString *)log {
    NSRange range = [log rangeOfString:@"]"];
    if (range.location != NSNotFound) {
        return [log substringToIndex:range.location + 1];
    }
    return @"[General]";
}

- (void)copyLogs {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[BHLogger allLogs] componentsJoinedByString:@"\n"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView.dataSource isEqual:self]) {
        return [self.sortedSections count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString *sectionTitle = self.sortedSections[indexPath.row];
    cell.textLabel.text = sectionTitle;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = self.sortedSections[indexPath.row];
    NSArray *logs = self.logs[sectionTitle];

    LogDetailViewController *logDetailVC = [[LogDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    logDetailVC.title = sectionTitle;
    logDetailVC.logs = logs;

    [self.navigationController pushViewController:logDetailVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Log Sections";
}
@end