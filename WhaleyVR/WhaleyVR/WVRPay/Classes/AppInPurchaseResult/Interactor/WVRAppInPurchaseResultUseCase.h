//
//  WVRAppInPurchaseResultUseCase.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRAppInPurchaseResultUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *iosTradeNo;
@property (nonatomic, copy) NSString *phoneNo;

@end
