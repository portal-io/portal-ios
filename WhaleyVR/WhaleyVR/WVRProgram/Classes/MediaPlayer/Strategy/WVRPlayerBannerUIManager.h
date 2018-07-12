//
//  WVRPlayerBannerUIManager.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIManager.h"


@interface WVRPlayerBannerUIManager : WVRPlayerUIManager

@property (nonatomic, assign) BOOL gIsUserPause;

-(void)updateContentView:(UIView*)contentView;

-(void)updateOriginDicForFull;
-(void)updateOriginDicForSmall;

- (void)changeViewFrameForSmall;
@end
