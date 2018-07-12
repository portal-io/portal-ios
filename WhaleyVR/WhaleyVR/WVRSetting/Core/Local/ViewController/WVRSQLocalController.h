//
//  WVRSQLocalCachController.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVREditTableViewController.h"
@class WVRVideoModel;

@interface WVRSQLocalController : WVREditTableViewController

+ (instancetype)shareInstance;

//updateCachVideoInfo 和 addDownTask不能同时调用 只能在app启动后调用一次
//- (void)updateCachVideoInfo;

- (void)addDownTask:(WVRVideoModel *)videoModel;
- (void)startDownWhenHaveNet;
-(void)cancleCurDownload;
@end
