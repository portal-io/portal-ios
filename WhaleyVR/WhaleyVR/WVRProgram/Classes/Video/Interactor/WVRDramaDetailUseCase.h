//
//  WVRDramaDetailUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情UseCase

#import "WVRUseCase.h"

@interface WVRDramaDetailUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString * code;

@end
