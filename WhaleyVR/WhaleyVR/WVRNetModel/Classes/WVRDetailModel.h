//
//  WVRDetailModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/26.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 清晰快速的分辨当前视频具体类型

#import <Foundation/Foundation.h>
#import "WVRDetailTypeHeader.h"

@interface WVRDetailModel : NSObject

/// NSString
@property (nonatomic, copy, readonly) NSString *detailTypeStr;

/// enum
@property (nonatomic, assign, readonly) WVRDetailType detailType;

/// VR || VRFootball
@property (nonatomic, assign, readonly) BOOL isVR;

/// Live || LiveFootball
@property (nonatomic, assign, readonly) BOOL isLive;

/// Drama
@property (nonatomic, assign, readonly) BOOL isDrama;

/// VRFootball || LiveFootball
@property (nonatomic, assign, readonly) BOOL isFootball;

/// Wasu3DMovie
@property (nonatomic, assign, readonly) BOOL isWasu;

/// TVMore2DTV || TVMore2DMovie
@property (nonatomic, assign, readonly) BOOL isTVMore;

/// TVMore2DTV || TVMore2DMovie
@property (nonatomic, assign, readonly) BOOL is2D;

- (instancetype)initWithDetailTypeStr:(NSString *)detailTypeStr;

@end
