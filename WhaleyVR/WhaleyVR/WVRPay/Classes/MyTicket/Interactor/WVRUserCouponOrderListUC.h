//
//  WVRUserCouponOrderListUC.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRUserCouponOrderListUC : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString * page;
@property (nonatomic, copy) NSString *size;

@end
