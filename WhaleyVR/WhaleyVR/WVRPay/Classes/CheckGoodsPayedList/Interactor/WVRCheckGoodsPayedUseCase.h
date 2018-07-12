//
//  WVRCheckGoodsPayedUseCase.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRCheckGoodsPayedUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *goodsNos;
@property (nonatomic, copy) NSString *goodsTypes;

- (RACCommand *)checkPayCmd;

@end
