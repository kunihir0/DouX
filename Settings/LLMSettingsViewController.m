#import "LLMSettingsViewController.h"
#import "BHIManager.h"

@interface LLMSettingsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *models;

@end

@implementation LLMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LLM Settings";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"llm_enabled"] ? 4 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if (indexPath.section == 0) {
        cell.textLabel.text = @"Enable LLM Integration";
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"llm_enabled"];
        [switchView addTarget:self action:@selector(toggleLLMEnabled:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Ollama API URL";
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            textField.placeholder = @"http://localhost:11434";
            textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"ollama_url"];
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            cell.accessoryView = textField;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Model";
                        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"selected_model"];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"System Prompt";
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            textField.placeholder = @"You are a helpful assistant.";
            textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"system_prompt"];
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            cell.accessoryView = textField;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Streaming Responses";
            UISwitch *switchView = [[UISwitch alloc] init];
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"streaming_responses"];
            [switchView addTarget:self action:@selector(toggleStreaming:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self fetchModels];
    }
}

#pragma mark - Actions

- (void)toggleLLMEnabled:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"llm_enabled"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)toggleStreaming:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"streaming_responses"];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.placeholder) {
        if ([textField.placeholder isEqualToString:@"http://localhost:11434"]) {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"ollama_url"];
        } else if ([textField.placeholder isEqualToString:@"You are a helpful assistant."]) {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"system_prompt"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - API

- (void)fetchModels {
    NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"ollama_url"];
    if (!urlString || urlString.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please set the Ollama API URL first." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/tags", urlString]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error fetching models: %@", error);
            return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.models = json[@"models"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showModelPicker];
        });
    }] resume];
}

- (void)showModelPicker {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a Model" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSDictionary *model in self.models) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:model[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:model[@"name"] forKey:@"selected_model"];
                [self.tableView reloadData];
            }];
            if ([model[@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"selected_model"]]) {
                [action setValue:@(YES) forKey:@"checked"];
            }
            [alert addAction:action];
        }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end