//
//  WVRFilteredWebCache.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRFilteredWebCache.h"
#import "WVRFilterManager.h"
#import "WVRFilePathTool.h"
#import "NSDate+Extend.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WVRFilteredWebCache

#pragma mark - init

+ (void)setDefauleCache {
    
    // create cache path
    NSString *defaultPath = [WVRFilePathTool getCachesWithName:@"webCache"];   // 默认缓存路径
    [WVRFilePathTool createFolderAtPath:defaultPath];
    [WVRFilePathTool createFolderAtPath:[[self class] cachePathWithName:nil]];
    
    // 设置默认cache类
    NSUInteger discCapacity = 500 * 1024 * 1024;
    NSUInteger memoryCapacity = 120 * 1024 * 1024;
    
    WVRFilteredWebCache *cache =
    [[WVRFilteredWebCache alloc] initWithMemoryCapacity:memoryCapacity
                                           diskCapacity:discCapacity diskPath:defaultPath];
    [NSURLCache setSharedURLCache:cache];
    
    // 设置cache文件有效期超时时间
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        
        NSString *cachePath = [[self class] cachePathWithName:nil];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        BOOL isExist = [fm fileExistsAtPath:cachePath isDirectory:&isDirectory];
        
        if (!isExist || !isDirectory) { return; }
        
        NSDirectoryEnumerator *myDirectoryEnumerator = [fm enumeratorAtPath:cachePath];
        
        NSString *tmpPath = nil;
        while((tmpPath = [myDirectoryEnumerator nextObject]))
        {
//            NSLog(@"tmpPath: - %@", tmpPath);
            if ([tmpPath containsString:@".DS"]) { continue; };
            
            NSString *itemPath = [cachePath stringByAppendingPathComponent:tmpPath];
            NSDictionary *dict = [fm attributesOfItemAtPath:itemPath error:nil];
            
            NSDate *date = dict[@"NSFileModificationDate"];
            if (!date) { continue; }
            
            long day = [NSDate getTimeDifferenceFormDate:date];
            
            if (day > 30) {
                [fm removeItemAtPath:itemPath error:nil];
            }
        }
    });
}

#pragma mark - 重写父类方法

- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    NSString *urlStr = url.absoluteString;
    
    BOOL blockURL = [WVRFilterManager shouldBlockURL:url];
    if (blockURL) {
        
        NSString *name = [[self class] cachedFileNameForKey:urlStr];
        NSString *path = [[self class] cachePathWithName:name];
        
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:path];
        
        if (fileData) {
            
            NSInteger contentLength = [fileData length];
            
            NSURLResponse *response =
            [[NSURLResponse alloc] initWithURL:url
                                      MIMEType:@"text/plain"
                         expectedContentLength:contentLength
                              textEncodingName:nil];
            
            NSCachedURLResponse *cachedResponse =
            [[NSCachedURLResponse alloc] initWithResponse:response
                                                     data:fileData];
            
            [super storeCachedResponse:cachedResponse forRequest:request];
        } else {
            // download for url
            [[self class] requestForUrl:urlStr];
        }
    }
    
    return [super cachedResponseForRequest:request];
}

#pragma mark - Cache (private)

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}

// 有用的缓存路径
+ (NSString *)cachePathWithName:(NSString *)name {
    
    NSString *str = @"webCache";
    if (name.length > 0) { str = [NSString stringWithFormat:@"webCache/%@", name]; }
    
    return [WVRFilePathTool getLibraryWithName:str];
}

+ (void)requestForUrl:(NSString *)URLStr {
    
    NSURL *url = [NSURL URLWithString:URLStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *name = [[self class] cachedFileNameForKey:url.absoluteString];
        NSString *path = [[self class] cachePathWithName:name];
        
//        [data writeToFile:path atomically:YES];
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }];
    
    [sessionDataTask resume];
}

@end
