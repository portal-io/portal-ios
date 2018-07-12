//
//  WVRPayMethodUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRPayMethodUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, assign) BOOL isRequesting;

/// 为了做开关而请求
@property (nonatomic, assign) BOOL requestForSwitch;

@end
