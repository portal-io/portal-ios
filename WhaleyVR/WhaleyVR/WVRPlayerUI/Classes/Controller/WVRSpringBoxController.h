//
//  WVRSpringBoxController.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 新春福卡抽奖

#import "WVRPlayerUIProtocol.h"

@interface WVRSpringBoxController : NSObject <WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
