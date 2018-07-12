//
//  WVRExchangeRedeemCodeUC.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"
#import "WVRPayGoodsType.h"

@interface WVRExchangeRedeemCodeUC : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *redeemCode;

- (RACCommand *)createOrderCmd;

@end
