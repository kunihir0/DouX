#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>
- (void)didApplyFilters:(NSDictionary *)filters;
@end

@interface FilterViewController : UITableViewController
@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *allCreators;
@property (nonatomic, strong) NSDictionary *selectedFilters;
@end
