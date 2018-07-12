//
//  SQCocoaHttpServerTool.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQCocoaHttpServerTool : NSObject

+ (instancetype)shareInstance;
- (void)openHttpServer;
- (void)stopHttpServer;


- (BOOL)isrunning;

@end
