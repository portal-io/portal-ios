//
//  WVRForgotPWValidCodeUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRForgotPWValidCodeUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * inputCode;
@end
