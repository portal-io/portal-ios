//
//  WVRPlayerLiveUIManager.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIManager.h"
#import "WVRPlayerViewLive.h"
#import "WVRLotteryBoxView.h"
#import "WVRGiftPresenter.h"
#import "WVRPlayGiftContainerCellViewModel.h"

@protocol WVRPlayerUILiveManagerDelegate <NSObject>

@required
- (void)actionEasterEggLottery;
- (void)actionGoGiftPage;
- (BOOL)actionCheckLogin;
- (void)actionGoRedeemPage;

- (void)shareBtnClick:(UIButton *)sender;

- (void)vrModeBtnClick:(UIButton *)sender;

@end


@interface WVRPlayerLiveUIManager : WVRPlayerUIManager

@property (nonatomic, weak) id<WVRPlayerUILiveManagerDelegate> uiLiveDelegate;

@property (nonatomic, strong) WVRPlayGiftContainerCellViewModel * gGiftContainerCellViewModel;

-(void)installGiftPresenter;

- (void)registerObserverEvent;
/// 当前播放器的主要交互控件
- (WVRPlayerViewLive *)playerView;

#pragma mark - exec function - playerView

- (void)execPlayCountUpdate:(long)playCount;

- (void)execNetworkStatusChanged;

- (void)execEasterEggCountdown:(long)time;
- (void)execLotterySwitch:(BOOL)isOn;
- (void)execDanmuSwitch:(BOOL)isOn;
- (void)execLotteryResult:(NSDictionary *)dict;

- (void)execOpenSocket;
- (void)execCloseSocket;

- (void)execDealWithUserLogin;

#pragma mark - textField

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn;
- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn;

@end
