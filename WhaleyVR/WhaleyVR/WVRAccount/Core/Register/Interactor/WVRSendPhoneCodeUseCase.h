//
//  WVRSendPhoneCodeUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRSendPhoneCodeUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * mobile;

@property (nonatomic, strong) NSString * smsToken;

@property (nonatomic, strong) NSString * inputCaptcha;

@end
