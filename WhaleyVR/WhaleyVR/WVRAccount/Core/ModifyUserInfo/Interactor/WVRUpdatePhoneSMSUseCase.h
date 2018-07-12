//
//  WVRUpdatePhoneUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRUpdatePhoneSMSUseCase : WVRAccountUseCase

@property (nonatomic, strong) NSString * inputPhoneNum;

@property (nonatomic, strong) NSString * smsToken;

@property (nonatomic, strong) NSString * inputCaptcha;

@end
