//
//  WVRLiveDetailViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRLiveDetailViewModel : WVRViewModel

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

@property (nonatomic, strong, readonly) RACCommand * gDetailCmd;

@end
