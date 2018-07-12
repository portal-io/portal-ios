//
//  WVRPlayLiveBottomCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayBottomCellViewModel.h"
#import "WVRPlayerBottomViewDelegate.h"
#import "WVRPlayerLiveBottomViewDelegate.h"

@interface WVRPlayLiveBottomCellViewModel : WVRPlayBottomCellViewModel

@property (nonatomic, assign) BOOL danmuSwitch;


/// 此值改变代表系统键盘动画完成
@property (nonatomic, assign) BOOL keyboardAnimatoinDone;
/// 此值改变代表系统键盘弹出状态改变
@property (nonatomic, assign) BOOL isKeyboardOn;

@end
