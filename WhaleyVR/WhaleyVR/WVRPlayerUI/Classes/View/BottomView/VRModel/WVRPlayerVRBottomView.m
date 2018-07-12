//
//  WVRPlayerVRBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVRBottomView.h"

@interface WVRPlayerVRBottomView()

//@property (nonatomic, strong) WVRPlayVRBottomCellViewModel * gViewModel;

@end


@implementation WVRPlayerVRBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)fillData:(WVRPlayViewCellViewModel *)args
{
    [super fillData:args];
    @weakify(self);
    [RACObserve(self.gViewModel, animationStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimating) {
            self.backBtn.hidden = YES;
        }else if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimationComplete) {
            self.backBtn.hidden = NO;
        }
    }];
}



- (void)updateStatus:(WVRPlayerToolVStatus)status
{
    [super updateStatus:status];
//    switch (status) {
//        case WVRPlayerToolVStatusError:
//            [self enableErrorStatus];
//            break;
//        default:
//            [self unableErrorStatus];
//            break;
//    }
}

//- (void)enableErrorStatus
//{
//    self.hidden = NO;
//    for (UIView * cur in self.subviews) {
//        cur.hidden = YES;
//    }
//    [self.superview bringSubviewToFront:self];
//    self.backBtn.hidden = NO;
//}
//
//- (void)unableErrorStatus
//{
//    self.hidden = NO;
//    for (UIView * cur in self.subviews) {
//        cur.hidden = NO;
//    }
//}

- (IBAction)backOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(backOnClick:)]) {
        [self.gViewModel.delegate backOnClick:sender];
    }
}

@end
