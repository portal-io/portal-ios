//
//  WVRDanmuController.h
//  WVRDanmu
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRPlayerUIProtocol.h"

@interface WVRDanmuController : NSObject<WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
