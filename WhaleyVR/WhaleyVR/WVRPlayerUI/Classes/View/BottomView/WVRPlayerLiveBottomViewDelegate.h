//
//  WVRPlayerLiveBottomViewDelegate.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRPlayerLiveBottomViewDelegate <NSObject>

@optional
//- (void)vrModeBtnClick:(UIButton *)sender;

- (void)actionDanmuMessageBtnClick;

- (void)actionGiftBtnClick;

- (BOOL)isCharged;
- (BOOL)actionCheckLogin;

@end
