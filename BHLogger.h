#import <Foundation/Foundation.h>

extern NSString * const BHLoggerDidAddLogNotification;

@interface BHLogger : NSObject

+ (void)log:(NSString *)message;
+ (NSArray *)allLogs;

@end