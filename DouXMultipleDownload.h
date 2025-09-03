#import <Foundation/Foundation.h>

@protocol DouXMultipleDownloadDelegate <NSObject>
@optional
- (void)downloader:(id)downloader didFinishDownloadingFile:(NSURL *)filePath atIndex:(NSInteger)index totalFiles:(NSInteger)total;
- (void)downloaderProgress:(float)progress;
- (void)downloaderDidFinishDownloadingAllFiles:(NSMutableArray<NSURL *> *)downloadedFilePaths;
- (void)downloaderDidFailureWithError:(NSError *)error;
@end

@interface DouXMultipleDownload : NSObject <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) id<DouXMultipleDownloadDelegate> delegate;
- (void)downloadFiles:(NSArray<NSURL *> *)fileURLs;

@end