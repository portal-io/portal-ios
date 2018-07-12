//
//  WVRLiveCompleteViewPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIProtocol.h"

@interface WVRLiveCompleteViewPresenter : NSObject <WVRPlayerUIProtocol>

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate;

@end
