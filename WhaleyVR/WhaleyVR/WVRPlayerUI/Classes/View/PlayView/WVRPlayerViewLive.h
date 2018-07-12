//
//  WVRPlayerViewLive.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerView.h"
#import "WVRPlayerViewDelegate.h"
@class WVRLiveTextField;

@interface WVRPlayerViewLive : WVRPlayerView

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;


//MARK: - live

- (void)execNetworkStatusChanged;

- (void)execLotteryResult:(NSDictionary *)dict;

@end
