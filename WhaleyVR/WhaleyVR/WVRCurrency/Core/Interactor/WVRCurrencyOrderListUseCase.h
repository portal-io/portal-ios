//
//  WVRCurrencyOrderListUseCase.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 用户鲸币订单列表UseCase

#import <WVRUseCase.h>

@interface WVRCurrencyOrderListUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end
