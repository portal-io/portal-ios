//
//  WVRPlayerBannerController.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVC360.h"
#import "WVRPlayerBannerUIManager.h"
#import "WVRPlayerBannerProtocol.h"

@interface WVRPlayerBannerController : WVRPlayerVC360

@property (nonatomic, assign) BOOL isLive;

-(instancetype)initWithContentView:(UIView*)contentView delegate:(id<WVRPlayerBannerProtocol>)delegate;

-(void)destory;

//-(void)destroyForUnity;

-(void)updateContentView:(UIView*)contentView;

-(void)startLoadPlay;

- (void)restartForLaunch;

-(void)stopForNext;

- (WVRPlayerBannerUIManager *)playerUI;

-(void)stop;

-(void)start;

@end
