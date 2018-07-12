//
//  WVRPlayViewCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCell.h"

@implementation WVRPlayViewCell

- (void)fillData:(WVRPlayViewCellViewModel *)args {
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    [self installRAC];
}

- (void)installRAC {
    @weakify(self);
    [RACObserve(self.gViewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
    }];
    [RACObserve(self.gViewModel, lockStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateLockStatus:self.gViewModel.lockStatus];
    }];
    [RACObserve(self.gViewModel, gPayStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updatePayStatus:self.gViewModel.gPayStatus];
    }];
    [RACObserve(self.gViewModel, viewIsHiden) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateHidenStatus:self.gViewModel.viewIsHiden];
    }];
    
}

- (void)updateHidenStatus:(BOOL)isHiden
{
    if (self.gViewModel.lockStatus == WVRPlayerToolVStatusLock) {
        return;
    }
    if (self.gViewModel.gPayStatus == WVRPlayerToolVStatusWatingPay) {//如果是等待支付状态，一切操作都不响应
        return;
    }
    self.hidden = isHiden;
}


- (void)updateLockStatus:(WVRPlayerToolVStatus)status
{
    DebugLog(@"play_UI_updateLockStatus:%d",(int)status);
    if (self.gViewModel.gDramaStatus == WVRPlayerToolVStatusWatingChooseDrama) {
        return;
    }
    switch (status) {
        case WVRPlayerToolVStatusNotLock:
            self.hidden = NO;
            break;
        case WVRPlayerToolVStatusLock:
            self.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    DebugLog(@"play_UI_updateStatus:%d", (int)status);
//    self.hidden = NO;
    switch (status) {
        case WVRPlayerToolVStatusWatingPay:
        case WVRPlayerToolVStatusError:
//            self.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    DebugLog(@"play_UI_updatePayStatus:%d (class:%@)", (int)status, self);
    switch (status) {
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        case WVRPlayerToolVStatusPaySuccess:
            [self enablePaySuccessStatus];
            break;
        default:
            break;
    }
}

- (void)enableWatingPayStatus
{
    
}

- (void)enablePaySuccessStatus
{
    
}

- (BOOL)playerUINotAutoShow {
    
    return YES;
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}

@end
