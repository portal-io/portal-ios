//
//  WVRPlayerViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerViewHeader.h"

@class WVRPlayViewViewModel, WVRPlayViewCell;

@protocol WVRPlayerViewProtocol <NSObject>

/**
 UI刷新（适应屏幕旋转等情况）
 */
- (void)reloadData;

- (void)loadSubViews ;

- (void)createLayout;

-(void)fillData:(WVRPlayViewViewModel *)args;

-(WVRPlayViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;

- (void)registerNib:(UINib*)nib forCellReuseIdentifier:(NSString *)identifier;

@required
- (void)updateFrame:(CGRect)frame;

- (CGSize)getViewSize;

- (void)hiddenV:(BOOL)hidden;

- (BOOL)isHiddenV;

- (WVRPlayerToolVQuality)getQuality;

@optional

- (WVRPlayerToolVStatus )getStatus;

- (void)updatePlayBtnStatus:(BOOL)isPlaying;

- (void)updateStatus:(WVRPlayerToolVStatus)status;

- (void)updateQuality:(WVRPlayerToolVQuality)quality;

- (void)updateQualityWithTitle:(NSString *)qualityTitle;

- (void)updateWillToQuality:(WVRPlayerToolVQuality)willQuality;

- (WVRPlayerToolVQuality)getWillToQuality;

//- (NSString *)actionChangeDefinition;

/**
 视频起播事件（切换完清晰度也会回调）

 @param duration 点播视频总时长
 */
//- (void)preparedWithDuration:(long)duration;

//- (void)updatePosition:(CGFloat)curPosition buffer:(CGFloat)buffer duration:(CGFloat)duration;

//- (void)stopLoadingAnimating;
//
//- (void)startLoadingAnimating;
//
//- (void)updateNetSpeed:(long)speed;
//
//- (void)updateTitle:(NSString *)title;

@end
