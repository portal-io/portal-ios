//
//  WVRPlayVRLiveBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 分屏模式下，直播的Bottom UI，目前没有用到，因为分屏跳到了Unity

#import "WVRPlayVRLiveBottomView.h"

@interface WVRPlayVRLiveBottomView()

@end


@implementation WVRPlayVRLiveBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *img = [UIImage roundImageWithColor:[UIColor colorWithWhite:0 alpha:0.3] frame:CGRectMake(0, 0, 35, 30) cornerRadius:30/2];
    [self.defiButton setBackgroundImage:img forState:UIControlStateNormal];
    self.defiButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args {
    self.gViewModel = args;
    [self installRAC];
}

- (void)installRAC {
    [super installRAC];
    
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel *)self.gViewModel), defiTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *title = x;
        if (title.length == 0) { return; }
        [self.defiButton setTitle:x forState:UIControlStateNormal];
    }];
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
    
}

- (void)vrModeBtnOnClick:(id)sender {
    // Do Nothing
}

@end
