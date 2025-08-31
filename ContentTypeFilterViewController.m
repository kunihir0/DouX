#import "ContentTypeFilterViewController.h"

@implementation ContentTypeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filter by Content Type";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"All";
            break;
        case 1:
            cell.textLabel.text = @"Photos";
            break;
        case 2:
            cell.textLabel.text = @"Videos";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContentTypeFilterChanged" object:@(indexPath.row)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
