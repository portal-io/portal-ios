//
//  SQCocoaHttpServerTool.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//


#import "SQCocoaHttpServerTool.h"
#import <HTTPServer.h>
#import "WVRCocoaHttpServerHeader.h"

@interface SQCocoaHttpServerTool ()

@property (nonatomic) HTTPServer* httpServer;

@end


@implementation SQCocoaHttpServerTool

+ (instancetype)shareInstance
{
    static SQCocoaHttpServerTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [SQCocoaHttpServerTool new];
    });
    return tool;
}

- (void)openHttpServer
{
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setType:@"_http._tcp."];  // 设置服务类型
    [self.httpServer setPort:SQCocoaHttpServerPort]; // 设置服务器端口
    
    NSLog(@"-------------\nSetting document root: %@\n", SQCocoaHttpServerRoot);
    // 设置服务器路径
    [self.httpServer setDocumentRoot:SQCocoaHttpServerRoot];
    NSError *error;
    if(![self.httpServer start:&error])
    {
        NSLog(@"-------------\nError starting HTTP Server: %@\n", error);
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:SQCocoaHttpServerRoot]) {
        /** 创建 */
        NSError *error2;
        BOOL createSuc2 = [[NSFileManager defaultManager] createDirectoryAtPath:SQCocoaHttpServerRoot withIntermediateDirectories:YES attributes:nil error:&error2];
        if (!createSuc2) {
            NSLog(@"创建失败:%@", error2);
        }
    }
}

- (void)stopHttpServer
{
    [self.httpServer stop];
}

- (BOOL)isrunning
{
    return self.httpServer.isRunning;
}


@end
