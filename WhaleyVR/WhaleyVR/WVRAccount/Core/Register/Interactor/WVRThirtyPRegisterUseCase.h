//
//  WVRThirtyPRegisterUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

//现在第三方注册是使用ThirtyPLoginUseCase,这个useCase没有用到
@interface WVRThirtyPRegisterUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, assign) NSInteger  origin;

@end
