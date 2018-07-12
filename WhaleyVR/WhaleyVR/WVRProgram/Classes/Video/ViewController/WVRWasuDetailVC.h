//
//  WVRWasuDetailVC.h
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 华数3D电影 页面

#import "WVRDetailVC.h"
#import "WVRVideoEntityWasuMovie.h"

@interface WVRWasuDetailVC : WVRDetailVC

// sid为必传字段
// sid 节目唯一id 在父类中

@property (nonatomic, copy, readonly) NSString *videoType;          // videoType

@property (nonatomic, assign, readonly) WVRVideoDetailType detailType;

- (instancetype)initWithSid:(NSString *)sid;

@end


@interface WVRTagLabel : UILabel

- (instancetype)initWithText:(NSString *)text;

@end
