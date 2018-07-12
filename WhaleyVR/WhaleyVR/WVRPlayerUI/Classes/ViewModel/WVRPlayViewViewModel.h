//
//  WVRPlayViewViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRPlayerViewHeader.h"

@interface WVRPlayViewViewModel : WVRViewModel

@property (nonatomic, assign) WVRPlayerToolVStatus lockStatus;
@property (nonatomic, assign) WVRPlayerToolVStatus playStatus;

@property (nonatomic, assign) BOOL viewIsHiden;

@property (nonatomic, assign) BOOL isRotationAnimating;
@property (nonatomic, assign) long errorCode;

/// 键盘正在显示，控件不自动隐藏
@property (nonatomic, assign) BOOL isKeyBoardShow;

@end
