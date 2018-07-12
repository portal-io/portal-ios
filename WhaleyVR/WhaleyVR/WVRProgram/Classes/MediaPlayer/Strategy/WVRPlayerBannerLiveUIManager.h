//
//  WVRPlayerBannerLiveUIManager.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveUIManager.h"

@interface WVRPlayerBannerLiveUIManager : WVRPlayerLiveUIManager

@property (nonatomic, assign) BOOL gIsUserPause;

- (void)updateContentView:(UIView *)contentView;

- (void)updateOriginDicForFull;
- (void)updateOriginDicForSmall;

- (void)forceToOrientationMaskLandscapeRight;

- (void)changeViewFrameForSmall;

@end
