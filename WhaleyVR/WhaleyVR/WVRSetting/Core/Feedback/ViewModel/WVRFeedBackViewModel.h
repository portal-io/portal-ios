//
//  WVRFeedBackViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRFeedBackViewModel : WVRViewModel

@property (nonatomic, strong) NSDictionary * params;


@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

@property (nonatomic, strong, readonly) RACCommand * gFeedBackCmd;

@end
