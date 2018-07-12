//
//  WVRPlayerFullSBottomViewLocal2DTV.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSBottomViewLocal.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"
#import "WVRPlayBottomCellViewModel.h"

@interface WVRPlayerFullSBottomViewLocal ()

@property (weak, nonatomic) IBOutlet UIButton *vrModeButton;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@end


@implementation WVRPlayerFullSBottomViewLocal
@synthesize gViewModel = _gViewModel;

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
    [RACObserve(self.gViewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
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

-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self updateLeadingCons];
}

@end
