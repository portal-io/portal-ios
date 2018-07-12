//
//  WVRVideoEntityLocal.h
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRVideoEntity.h"

@interface WVRVideoEntityLocal : WVRVideoEntity

/**
 本地视频 播放时需要传递渲染类型
 */
@property (assign, nonatomic) WVRRenderType renderType;

/**
 本地视频（非下载）播放时需要传递方向参数
 */
//@property (assign, nonatomic) FrameOritation oritaion;


@end
