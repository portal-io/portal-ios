//
//  WVRPlayLiveBannerBottomCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayLiveBannerBottomCell.h"
#import "WVRPlayLiveBottomCellViewModel.h"

@interface WVRPlayLiveBannerBottomCell()

@end


@implementation WVRPlayLiveBannerBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initViews];
}

- (void)installRAC
{
    @weakify(self);
    [[RACObserve(self.gViewModel, playStatus) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
    }];
}

- (void)fillData:(WVRPlayLiveBottomCellViewModel *)args
{
    self.gViewModel = args;
    [self installRAC];
}

- (void)initViews {
    
    //    self.textFieldV.realDelegate = self.clickDelegate;
    [self.fullBtn addTarget:self action:@selector(fullBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.launchBtn addTarget:self action:@selector(launchOnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)fullBtnOnClick:(UIButton*)sender {
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(fullOnClick:)]) {
        [self.gViewModel.delegate fullOnClick:sender];
    }
}

- (void)launchOnClick:(UIButton *)sender
{
    if ([self.gViewModel.delegate respondsToSelector:@selector(launchOnClick:)]) {
        [self.gViewModel.delegate launchOnClick:sender];
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            [self enableDefaultStatus];
            break;
        case WVRPlayerToolVStatusPrepared:
            [self enablePrepareStatus];
            break;
        case WVRPlayerToolVStatusPlaying:
            [self enablePlayingStatus];
            break;
        case WVRPlayerToolVStatusPause:
            [self enablePauseStatus];
            break;
        case WVRPlayerToolVStatusStop:
            [self enableStopStatus];
            break;
        case WVRPlayerToolVStatusError:
            [self enableErrorStatus];
            break;
            
        default:
            break;
    }
}

- (void)enableDefaultStatus {
    
    //    self.startBtn.selected = NO;
    //    self.startBtn.userInteractionEnabled = NO;
    //    self.processSlider.enabled = NO;
    
}

- (void)enablePrepareStatus {
    
    //    self.startBtn.selected = YES;
    //    self.startBtn.userInteractionEnabled = YES;
    //    self.processSlider.enabled = YES;
    
}

- (void)enablePlayingStatus {
    
    //    self.startBtn.selected = YES;
    //    self.startBtn.userInteractionEnabled = YES;
    //    self.processSlider.enabled = YES;
    
}

- (void)enablePauseStatus {
    
    //    self.startBtn.selected = NO;
    //    self.startBtn.userInteractionEnabled = YES;
    //    self.processSlider.enabled = YES;
    
}

- (void)enableStopStatus {
    
    //    self.startBtn.selected = NO;
    //    self.startBtn.userInteractionEnabled = YES;
    //    self.processSlider.enabled = YES;
    
}

- (void)enableErrorStatus {
    
    //    self.startBtn.selected = NO;
    //    self.startBtn.userInteractionEnabled = NO;
    //    self.processSlider.enabled = NO;
    
}

- (void)enableHidenStatus {
    
    self.hidden = YES;
}

- (void)enableShowStatus {
    
    self.hidden = NO;
}

@end

