//
//  WVRDramaDetailVC.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/13.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情页

#import "WVRDetailVC.h"

@interface WVRDramaDetailVC : WVRDetailVC

// 以下为可选字段
// sid 节目唯一id 在父类中

@property (nonatomic, copy, readonly) NSString *videoType;          // videoType

@property (nonatomic, assign, readonly) WVRVideoDetailType detailType;

@property (nonatomic, assign) long historyPosition;

- (instancetype)initWithSid:(NSString *)sid;

@end
