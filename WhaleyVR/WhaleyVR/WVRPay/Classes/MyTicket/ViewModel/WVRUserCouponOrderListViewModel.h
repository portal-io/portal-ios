//
//  WVRUserCouponOrderListViewModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRUserCouponOrderListViewModel : WVRViewModel

@property (nonatomic, strong) NSString * page;
@property (nonatomic, strong) NSString * size;

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

- (RACCommand *)requestCmd;

@end
