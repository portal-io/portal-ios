//
//  WVRChartletManager.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 协助控制器管理播放器的背景图和底图

#import <Foundation/Foundation.h>
@class WVRVideoEntity, WVRPlayerHelper, WVRItemModel;

@interface WVRChartletManager : NSObject

- (void)createPlayerBottomImageWithVideoEntity:(WVRVideoEntity *)ve player:(WVRPlayerHelper *)player detailModel:(WVRItemModel *)detailModel;

- (void)createPlayerFootballBackgroundImageWithVIP:(BOOL)isVIP ve:(WVRVideoEntity *)ve player:(WVRPlayerHelper *)player detailModel:(WVRItemModel *)detailModel;

@end
