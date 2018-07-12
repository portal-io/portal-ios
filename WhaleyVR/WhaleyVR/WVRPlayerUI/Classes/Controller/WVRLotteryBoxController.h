//
//  WVRLotteryBoxController.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIProtocol.h"

@interface WVRLotteryBoxController : NSObject <WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
