//
//  WVRCreateOrderUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"
#import "WVRPayGoodsType.h"

@interface WVRCreateOrderUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *goodCode;
@property (nonatomic, copy) NSString *goodType;
@property (nonatomic, assign) long goodPrice;
@property (nonatomic, assign) WVRPayPlatform payPlatform;

- (RACCommand *)createOrderCmd;

@end
