//
//  WVRPlayerViewProtocol.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIConst.h"

#pragma mark - player UI protocol


@protocol WVRPlayerViewDelegate <NSObject>

@required

//- (NSString *)actionChangeDefinition;

- (void)actionBackBtnClick;

- (void)actionRetry;        // 此代理在startView里面调用

- (void)actionSetControlsVisible:(BOOL)isControlsVisible;

- (void)actionTouchesBegan;
- (void)actionPanGustrue:(float)x Y:(float)y;

- (NSDictionary *)actionGetVideoInfo:(BOOL)needRefresh;
- (BOOL)currentVideoIsDefaultVRMode;
- (BOOL)currentIsDefaultSD;

//- (NSString *)definitionToTitle:(NSString *)defi;
- (DefinitionType)definitionToType:(NSString *)defi;

//MARK: - pay

- (void)actionGotoBuy;
- (BOOL)isCharged;

- (BOOL)actionCheckLogin;

//MARK: - football

- (void)actionChangeCameraStand:(NSString *)standType;
- (NSArray<NSDictionary<NSString *, NSNumber *> *> *)actionGetCameraStandList;

//MARK: - 播放器状态信息

- (BOOL)isOnError;
- (BOOL)isPrepared;

- (BOOL)isWaitingForPlay;

@end


#pragma mark - live player UI protocol


@protocol WVRPlayerViewLiveDelegate <NSObject>

@required
- (void)actionEasterEggLottery;
- (void)actionGoGiftPage;
- (BOOL)actionCheckLogin;
- (void)actionGoRedeemPage;
- (BOOL)isKeyboardOn;

- (void)shareBtnClick:(UIButton *)sender;

@end

