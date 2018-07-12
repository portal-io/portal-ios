//
//  WVRPlayerBottomViewDelegate.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRPlayerBottomViewDelegate <NSObject>

@optional
/**
 播放-暂停按钮点击触发事件

 @param view 触发事件的按钮
 @return 当前播放状态 isPlaying
 */
- (void)backOnClick:(UIButton *)sender;

- (BOOL)playOnClick:(BOOL)isPlay;

- (void)fullOnClick:(UIButton *)sender;

- (void)launchOnClick:(UIButton *)sender;

- (void)sliderDragEnd:(UISlider *)slider;

- (void)chooseQuality;

//- (void)chooseVRMode:(BOOL)isVR;

// 切换多机位
- (void)actionChangeCameraStand:(NSString *)standType;

- (NSArray<NSDictionary<NSString *, NSNumber *> *> *)actionGetCameraStandList;

@end
