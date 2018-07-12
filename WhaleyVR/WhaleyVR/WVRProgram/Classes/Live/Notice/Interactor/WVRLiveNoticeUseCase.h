//
//  WVRAllChannelUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRLiveNoticeUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * code;

@end
