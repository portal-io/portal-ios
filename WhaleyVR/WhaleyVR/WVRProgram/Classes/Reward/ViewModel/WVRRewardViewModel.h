//
//  WVREditAddressViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRRewardVCModel.h"

@interface WVRRewardViewModel : WVRViewModel

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getRewardCmd;

@end
