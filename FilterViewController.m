#import "FilterViewController.h"

@interface FilterViewController ()
@property (nonatomic, strong) NSMutableDictionary *currentFilters;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(apply)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    
    self.currentFilters = [self.selectedFilters mutableCopy];
    if (!self.currentFilters) {
        self.currentFilters = [NSMutableDictionary dictionary];
    }
}

- (void)apply {
    [self.delegate didApplyFilters:self.currentFilters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reset {
    [self.currentFilters removeAllObjects];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Favorites";
    } else if (section == 1) {
        return @"Content Type";
    }
    return @"Creator";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3; // All, Photos, Videos
    }
    return self.allCreators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Show Only Favorites";
        UISwitch *switchView = [[UISwitch alloc] init];
        NSNumber *showFavorites = self.currentFilters[@"showFavorites"];
        switchView.on = [showFavorites boolValue];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: cell.textLabel.text = @"All"; break;
            case 1: cell.textLabel.text = @"Photos"; break;
            case 2: cell.textLabel.text = @"Videos"; break;
        }
        
        NSNumber *selectedType = self.currentFilters[@"contentType"];
        if (selectedType && [selectedType integerValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        NSString *creator = self.allCreators[indexPath.row];
        cell.textLabel.text = creator;
        
        NSArray *selectedCreators = self.currentFilters[@"creators"];
        if ([selectedCreators containsObject:creator]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // Do nothing for the switch cell
    } else if (indexPath.section == 1) {
        self.currentFilters[@"contentType"] = @(indexPath.row);
    } else {
        NSString *creator = self.allCreators[indexPath.row];
        NSMutableArray *selectedCreators = [self.currentFilters[@"creators"] mutableCopy];
        if (!selectedCreators) {
            selectedCreators = [NSMutableArray array];
        }
        
        if ([selectedCreators containsObject:creator]) {
            [selectedCreators removeObject:creator];
        } else {
            [selectedCreators addObject:creator];
        }
        self.currentFilters[@"creators"] = selectedCreators;
    }
    
    [self.tableView reloadData];
}

- (void)switchChanged:(UISwitch *)sender {
    self.currentFilters[@"showFavorites"] = @(sender.on);
}

@end