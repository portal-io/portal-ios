//
//  WVRVideoDetailVC.h
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// VR详情页面

#import "WVRDetailVC.h"

@interface WVRVideoDetailVC : WVRDetailVC

// 以下为可选字段
// sid 节目唯一id 在父类中

@property (nonatomic, copy) NSString *resource_code;                // recommend keyWord  tags字段

@property (nonatomic, copy, readonly) NSString *videoType;          // videoType

@property (nonatomic, assign, readonly) WVRVideoDetailType detailType;

@property (nonatomic, assign) long historyPosition;

- (instancetype)initWithSid:(NSString *)sid;

@end
