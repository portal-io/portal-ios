//
//  SQDownloadTask.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/20.
//  Copyright © 2017年 qbshen. All rights reserved.
//


#import "SQDownload.h"


@interface SQDownload ()

@property (nonatomic, copy, readwrite) NSURL *downloadURL;
@property (nonatomic, copy, readwrite) NSString *fileName;

@property (nonatomic) NSURL * directory;

@end
@implementation SQDownload
#pragma mark - Init

- (instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName delegate:(id<SQDownloadDelegate> _Nullable)delegate
{
    self = [super init];
    if (self) {
        _downloadTask = downloadTask;
        self.directory = directory;
        self.fileName = fileName;
        _delegate = delegate;
    }
    return self;
}

- (instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName progression:(ProgressionHandlerType)progressHandler
                   completion:(CompletionHandlerType)completeHandler
{
    self = [super init];
    if (self) {
        _downloadTask = downloadTask;
        self.directory = directory;
        self.fileName = fileName;
        _progressionHandler = progressHandler;
        _completionHandler = completeHandler;
    }
    return self;
}

//- (NSURL *)destinationURL
//{
//    NSURL *destinationPath = self.directory? :[NSURL fileURLWithPath:NSTemporaryDirectory()];
//
//    return [NSURL URLWithString:self.fileName relativeToURL:destinationPath].URLByStandardizingPath;
//}
/*
 2017-10-26 15:12:54.094554+0800 WhaleyVR[14088:6092713] CFURLResourceIsReachable failed because it was passed an URL which has no scheme
 2017-10-26 15:12:54.113213+0800 WhaleyVR[14088:6090759] CFURLCopyResourcePropertyForKey failed because it was passed an URL which has no scheme
 2017-10-26 15:12:54.117534+0800 WhaleyVR[14088:6090759] error: Error Domain=NSCocoaErrorDomain Code=4 "文件“tvn8opxypqxz_oct1k2MVR.ts”不存在。" UserInfo={NSFileOriginalItemLocationKey=tvn8opxypqxz_oct1k2MVR.ts -- /var/mobile/Containers/Data/Application/FB97AD9B-21EF-4039-9A32-EDA7863DE185/Library/Caches/videoCach/tvn8opxypqxz/tvn8opxypqxz_oct1k2MVR.ts, NSURL=tvn8opxypqxz_oct1k2MVR.ts -- /var/mobile/Containers/Data/Application/FB97AD9B-21EF-4039-9A32-EDA7863DE185/Library/Caches/videoCach/tvn8opxypqxz/tvn8opxypqxz_oct1k2MVR.ts, NSFileNewItemLocationKey=file:///private/var/mobile/Containers/Data/Application/FB97AD9B-21EF-4039-9A32-EDA7863DE185/Library/Caches/com.apple.nsurlsessiond/Downloads/com.snailvr.glasswork/CFNetworkDownload_R8xCLs.tmp, NSUnderlyingError=0x1c1e40210 {Error Domain=NSCocoaErrorDomain Code=4 "文件“CFNetworkDownload_R8xCLs.tmp”不存在。" UserInfo={NSURL=file:///private/var/mobile/Containers/Data/Application/FB97AD9B-21EF-4039-9A32-EDA7863DE185/Library/Caches/com.apple.nsurlsessiond/Downloads/com.snailvr.glasswork/CFNetworkDownload_R8xCLs.tmp, NSFilePath=/private/var/mobile/Containers/Data/Application/FB97AD9B-21EF-4039-9A32-EDA7863DE185/Library/Caches/com.apple.nsurlsessiond/Downloads/com.snailvr.glasswork/CFNetworkDownload_R8xCLs.tmp, NSUnderlyingError=0x1c1a5ab20 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}}}

 */
- (NSURL *)destinationURL
{
    NSURL *destinationPath = self.directory? :[NSURL fileURLWithPath:NSTemporaryDirectory()];
    //    NSString * filePath = [NSString stringWithFormat:@"%@%@",destinationPath,self.fileName];
    NSURL * resultFilePath = [NSURL fileURLWithPath:destinationPath.absoluteString];
    //    return resultFilePath;
    return [NSURL fileURLWithPath:self.fileName relativeToURL:resultFilePath].URLByStandardizingPath;
    //文件路径URL要使用fileURLWithPath创建
}

- (void)cancel
{
    _state = SQDownloadStateCancelled;
    [self cancelWithResumeData:nil];
}


- (void)suspend
{
    _state = SQDownloadStatePause;
    [self.downloadTask suspend];
}

- (void)resume
{
    _state = SQDownloadStateDownloading;
    [self.downloadTask resume];
}

- (void)finish
{
    _state = SQDownloadStateDone;
    [self removeCacheDataWhenComplete];
}

- (void)cancelWithResumeData:(void (^ _Nullable)(NSData * _Nullable resumeData))completionHandler{
    __weak typeof(self) weakSelf = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        _resumeData = resumeData;
        [weakSelf writeCacheData:resumeData];
        if (completionHandler) {
            completionHandler(resumeData);
        }
        _progressionHandler = nil;
        _completionHandler = nil;
        _downloadTask = nil;
    }];
}

- (BOOL)writeCacheData:(NSData*)resumeData
{
    BOOL result = NO;
    if (resumeData != nil) {
        //文件路径
        NSString * curDir = [self.directory.absoluteString stringByReplacingOccurrencesOfString:self.fileName withString:@""];
        NSString *filePath = [curDir stringByAppendingString:[@"tmp_" stringByAppendingString:self.fileName]];
        //删除上次中断保存的Data
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        //重新保存Data
        NSError * filerResumeDataWriteError;
         result = [resumeData writeToFile:filePath options:NSDataWritingWithoutOverwriting error:&filerResumeDataWriteError];
        NSLog(@"resumeData svae : %@ result:%d",filerResumeDataWriteError.userInfo,result);
    }
    return result;
}


- (BOOL)removeCacheDataWhenComplete
{
    BOOL result = NO;
    NSString *filePath = [self.directory.absoluteString stringByAppendingPathComponent:[@"tmp_" stringByAppendingString:self.fileName]];
    //删除上次中断保存的Data
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    return result;
}

- (BOOL)removeDownloadFile
{
    BOOL result = NO;
    NSString *filePath = self.directory.absoluteString;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * fileremoveError;
    result =[fileManager removeItemAtPath:filePath error:&fileremoveError];
    NSLog(@"removeDownloadFile : %@ result:%d",fileremoveError.userInfo,result);
    return result;
}

- (void)dealloc{
    NSLog(@"%@ dealloc called",[self class]);
}
@end

