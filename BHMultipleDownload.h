#import <Foundation/Foundation.h>

@protocol BHMultipleDownloadDelegate <NSObject>
@optional
- (void)downloader:(id)downloader didFinishDownloadingFile:(NSURL *)filePath atIndex:(NSInteger)index totalFiles:(NSInteger)total;
- (void)downloaderProgress:(float)progress;
- (void)downloaderDidFinishDownloadingAllFiles:(NSMutableArray<NSURL *> *)downloadedFilePaths;
- (void)downloaderDidFailureWithError:(NSError *)error;
@end

@interface BHMultipleDownload : NSObject <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) id<BHMultipleDownloadDelegate> delegate;
- (void)downloadFiles:(NSArray<NSURL *> *)fileURLs;

@end