//
//  WVRPlayerBannerLiveController.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVCLive.h"
#import "WVRPlayerBannerLiveUIManager.h"
#import "WVRPlayerBannerProtocol.h"

@interface WVRPlayerBannerLiveController : WVRPlayerVCLive

-(instancetype)initWithContentView:(UIView*)contentView delegate:(id<WVRPlayerBannerProtocol>)delegate;

-(void)stopForNext;

-(void)destory;

-(void)destroyForUnity;

-(void)updateContentView:(UIView*)contentView;

-(void)startLoadPlay;

- (void)restartForLaunch;

- (WVRPlayerBannerLiveUIManager *)playerUI;

-(void)stop;

-(void)start;
@end
