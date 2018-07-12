//
//  WVRUserRedeemCodeViewModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRUserRedeemCodeViewModel : WVRViewModel

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

- (RACCommand *)requestCmd;

@end
