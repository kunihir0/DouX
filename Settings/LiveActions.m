#import "LiveActions.h"

@interface LiveActions () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *liveFuncValues;  // Holds the dictionaries of country details
@property (nonatomic, strong) UITableView *tableView; // The table view to show the list
@property (nonatomic, strong) NSArray *liveFuncTitles;

@end

@implementation LiveActions

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Live Button Actions";
    self.liveFuncTitles = @[@"Default", @"DouX++ Settings", @"Playback Speed"];
    self.liveFuncValues = @[@0, @1, @2];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

// Number of rows should be equal to the number of countries in the list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveFuncValues.count;
}

// Configure the cell to display the country name
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Set the country name in the cell
    cell.textLabel.text = self.liveFuncTitles[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

// Handle selection of a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get the selected country's dictionary
    NSNumber *selectedLiveOption = self.liveFuncTitles[indexPath.row];
    
    // Save the selected country dictionary to NSUserDefaults under the key "region"
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.liveFuncValues[indexPath.row] forKey:@"live_action"];
    [defaults synchronize];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Live Option Selected" message:[NSString stringWithFormat:@"You selected: %@", self.liveFuncTitles[indexPath.row]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionSelectedNotification"
                                                        object:nil
                                                      userInfo:@{@"selected action": selectedLiveOption}];
}

@end
