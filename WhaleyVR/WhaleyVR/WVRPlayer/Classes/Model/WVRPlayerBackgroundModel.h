//
//  WVRPlayerBackgroundModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 存储播放器中背景图和底图的信息

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WVRPlayerBackgroundModel : NSObject

/**
 当前渲染底图对应的视频id
 */
@property (nonatomic, copy) NSString *bottomSid;

/**
 底图的显示与隐藏
 */
@property (nonatomic, assign) BOOL bottomImageHidden;

/**
 底图
 */
@property (nonatomic, strong) UIImage *bottomImage;

/**
 透明的图片
 */
@property (nonatomic, readonly) UIImage *clearImage;

/**
 底图显示比例
 */
@property (nonatomic, assign) float bottomImageScale;

/**
 当前渲染背景图对应的视频id
 */
@property (nonatomic, copy) NSString *bgSid;

/**
 背景图（180视频独有）
 */
@property (nonatomic, strong) UIImage *bgImage;

/**
 是否为足球vip机位
 */
@property (nonatomic, assign) BOOL isVip;

@end
