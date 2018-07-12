//
//  WVRVideoDetailUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 全景视频/华数3D电影详情接口

#import "WVRUseCase.h"

@interface WVRVideoDetailUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString * code;

@end
