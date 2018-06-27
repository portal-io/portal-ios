//
//  WVRGetPhoneCodeTokenUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRGetPhoneCodeTokenUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * smsToken;

@end
