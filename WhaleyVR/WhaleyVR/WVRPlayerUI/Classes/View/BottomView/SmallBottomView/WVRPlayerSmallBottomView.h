//
//  WVRSmallPlayerToolView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 全景点播，华数视频（点播）

#import "WVRPlayViewCell.h"
#import "WVRPlayerSmallBottomViewProtocol.h"
#import "WVRPlayerBottomViewDelegate.h"
#import "WVRPlayBottomCellViewModel.h"

@class WVRSlider;

#define HEIGHT_DEFAULT (50.f)

@interface WVRPlayerSmallBottomView : WVRPlayViewCell<WVRPlayerSmallBottomViewProtocol>

//@property (nonatomic, strong) WVRPlayBottomCellViewModel * gViewModel;

//@property (nonatomic,weak) id<WVRPlayerBottomViewDelegate> clickDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnLeadingCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastRigtBtnTrainingCons;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIButton *defiButton;

@property (weak, nonatomic) IBOutlet UIButton *fullBtn;

@property (weak, nonatomic) IBOutlet UIButton *launchBtn;

@property (weak, nonatomic) IBOutlet WVRSlider *processSlider;

@property (weak, nonatomic) IBOutlet UILabel *curTimeL;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;

//- (void)fullBtnOnClick:(UIButton *)sender;

//- (void)hiddenForScreenRotation:(NSNumber *)needHidden;

//- (BOOL)isPlayerViewSubWidget;

#pragma mark - 暴漏给子类

- (UIColor *)enableColor;
- (UIColor *)disableColor;

- (void)updatePosition:(CGFloat)curPosition buffer:(CGFloat)buffer duration:(CGFloat)duration;

- (void)installRAC;
- (void)updateLeadingCons;

@end
