//
//  ViewController.h
//  StaticTableView
//
//  Created by raul on 08/10/2024.
//

#import <UIKit/UIKit.h>
#import "TikTokHeaders.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
- (UITableViewCell *)createSwitchCellWithTitle:(NSString *)title Detail:(NSString *)detail Key:(NSString *)key;


@end

