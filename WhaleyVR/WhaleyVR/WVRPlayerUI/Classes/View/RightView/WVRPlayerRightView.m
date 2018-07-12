//
//  WVRPlayerLeftToolView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerRightView.h"
#import "WVRPlayRightCellViewModel.h"

@interface WVRPlayerRightView ()

- (IBAction)resetBtnOnClick:(id)sender;

@end


@implementation WVRPlayerRightView

-(void)fillData:(WVRPlayRightCellViewModel *)args
{
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    
    [self installRAC];
}

-(void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(self.gViewModel, gDramaStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateDramaStatus:[x integerValue]];
    }];
    
}

-(void)updateHidenStatus:(BOOL)isHiden
{
    if ((self.gViewModel.lockStatus == WVRPlayerToolVStatusLock)||(self.gViewModel.gDramaStatus == WVRPlayerToolVStatusWatingChooseDrama)) {
        return;
    }
    self.hidden = isHiden;
}

- (IBAction)resetBtnOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(resetBtnOnClick:)]) {
        [self.gViewModel.delegate resetBtnOnClick:sender];
    }
}

- (void)updateDramaStatus:(WVRPlayerToolVStatus)status {
    switch (status) {
        case WVRPlayerToolVStatusWatingChooseDrama:
            self.hidden = YES;
            break;
        case WVRPlayerToolVStatusPreChooseDrama:
        case WVRPlayerToolVStatusChoosedDrama:
            if (self.gViewModel.lockStatus != WVRPlayerToolVStatusLock) {
                self.hidden = self.gViewModel.viewIsHiden;
            }
            break;
        default:

            break;
    }
    
}

-(void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePayStatus:status];
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

-(void)enableWatingPayStatus
{
    self.hidden = YES;
}

-(void)enablePaySuccessStatus
{
    self.hidden = NO;
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];

    switch (status) {
        case WVRPlayerToolVStatusDefault:
            
            break;
        case WVRPlayerToolVStatusPrepared:
            
            break;
        case WVRPlayerToolVStatusPlaying:
            
            break;
        case WVRPlayerToolVStatusPause:
            
            break;
        case WVRPlayerToolVStatusStop:
            
            break;
        case WVRPlayerToolVStatusError:
        
            break;
        default:
            break;
    }
}

-(BOOL)playerUINotAutoShow
{
    return YES;//(self.gViewModel.lockStatus == WVRPlayerToolVStatusLock)||(self.gViewModel.gDramaStatus == WVRPlayerToolVStatusWatingChooseDrama);
}
- (BOOL)playerUINotAutoHide {
    
    return YES;
}
@end
