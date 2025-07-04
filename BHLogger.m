#import "BHLogger.h"

NSString * const BHLoggerDidAddLogNotification = @"BHLoggerDidAddLogNotification";
static NSMutableArray *_logs;

@implementation BHLogger

+ (void)initialize {
    if (self == [BHLogger class]) {
        _logs = [NSMutableArray array];
    }
}

+ (void)log:(NSString *)message {
    NSLog(@"BHTikTok++: %@", message);
    [_logs addObject:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:BHLoggerDidAddLogNotification object:nil];
}

+ (NSArray *)allLogs {
    return [_logs copy];
}

@end