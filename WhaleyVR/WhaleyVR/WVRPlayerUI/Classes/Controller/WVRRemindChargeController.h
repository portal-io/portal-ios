//
//  WVRRemindChargeController.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIProtocol.h"

@interface WVRRemindChargeController : NSObject <WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
