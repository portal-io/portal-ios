//
//  WVRCurrencyCostUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币消费UseCase

// https://git.moretv.cn/vr-service/doc/blob/master/%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3/%E6%8E%A5%E5%8F%A3/%E7%94%A8%E6%88%B7%E9%B2%B8%E5%B8%81%E6%B6%88%E8%B4%B9%E6%8E%A5%E5%8F%A3.md

#import <WVRUseCase.h>

@interface WVRCurrencyCostUseCase : WVRUseCase<WVRUseCaseProtocol>

/** 购买类型（REDUCE_GIFT：礼物, REDUCE_COUPON: 券） */
@property (nonatomic, copy) NSString *buyType;

/** 购买参数（礼物code，券code） */
@property (nonatomic, copy) NSString *buyParams;

/** 涉及的业务参数（1、直播code；2、直播code+','+直播成员code 3、券名称） */
@property (nonatomic, copy) NSString *bizParams;

@end
