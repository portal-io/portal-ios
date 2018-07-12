//
//  WVRCurrencyBalanceUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币余额UseCase

#import <WVRUseCase.h>

@interface WVRCurrencyBalanceUseCase : WVRUseCase<WVRUseCaseProtocol>

- (RACCommand *)requestCmd;

@end
