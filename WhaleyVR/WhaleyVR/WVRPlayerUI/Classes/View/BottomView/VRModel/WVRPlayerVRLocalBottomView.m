//
//  WVRPlayerVRLocalBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVRLocalBottomView.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"

@interface WVRPlayerVRLocalBottomView ()

//@property (weak, nonatomic) IBOutlet UIButton *vrModeButton;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@end

@implementation WVRPlayerVRLocalBottomView

static NSString *kVRModeTitle = @"眼镜模式";
static NSString *kMocuModeTitle = @"手机模式";

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), position) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updatePosition:((WVRPlayBottomCellViewModel*)self.gViewModel).position buffer:((WVRPlayBottomCellViewModel*)self.gViewModel).bufferPosition duration:((WVRPlayBottomCellViewModel*)self.gViewModel).duration];
    }];
    [RACObserve(self.gViewModel, animationStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimating) {
            self.backBtn.hidden = YES;
        } else if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimationComplete) {
            self.backBtn.hidden = NO;
        }
    }];
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args {
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    self.processSlider.realDelegate = self.gViewModel.delegate;
    [self installRAC];
}

@end
