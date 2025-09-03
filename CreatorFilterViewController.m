#import "CreatorFilterViewController.h"

@implementation CreatorFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filter by Creator";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.creators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Clear Filter";
        cell.textLabel.textColor = [UIColor systemRedColor];
    } else {
        cell.textLabel.text = self.creators[indexPath.row];
        cell.textLabel.textColor = [UIColor labelColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *creator = nil;
    if (indexPath.section == 1) {
        creator = self.creators[indexPath.row];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatorFilterChanged" object:creator];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
