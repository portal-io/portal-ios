//
//  WVRModifyNickNameViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRModifyNickNameViewModel : WVRViewModel

@property (nonatomic, strong) NSString * nickName;

@property (nonatomic, strong) NSString * responseMsg;

@property (nonatomic, strong, readonly) RACSignal * completeSignal;

-(RACCommand*)modifyNickNameCmd;

@end
