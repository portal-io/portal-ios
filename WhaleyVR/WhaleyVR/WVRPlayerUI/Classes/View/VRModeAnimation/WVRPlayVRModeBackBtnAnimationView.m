//
//  WVRPlayVRModeBackBtnAnimationView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayVRModeBackBtnAnimationView.h"
#import "WVRPlayViewCellViewModel.h"

@interface WVRPlayVRModeBackBtnAnimationView()

@end

@implementation WVRPlayVRModeBackBtnAnimationView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.hidden = YES;
}

-(void)fillData:(WVRPlayViewCellViewModel *)args
{
    if(self.gViewModel == args){
        return;
    }
    self.gViewModel = args;
    @weakify(self);
    self.gViewModel.gAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimation:NO];
        });
        return [RACSignal empty];
    }];
    
    self.gViewModel.gUpAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimation:YES];
        });
        return [RACSignal empty];
    }];
    
    [RACObserve(self.gViewModel, animationStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateAnimationStatus:self.gViewModel.animationStatus];
    }];
}

-(void)updateAnimationStatus:(WVRPlayerToolVStatus)status
{
    switch (status) {
        case WVRPlayerToolVStatusAnimating:
            self.hidden = NO;
            break;
        case WVRPlayerToolVStatusAnimationComplete:
            self.hidden = YES;
            break;
            
        default:
            break;
    }
}

-(void)startAnimation:(BOOL)isUp
{
    self.gViewModel.animationStatus = WVRPlayerToolVStatusAnimating;
    self.hidden = NO;
    if (isUp) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCREEN_HEIGHT-HEIGHT_TOP_VIEW_DEFAULT);
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
    }
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.6 animations:^{
        if (isUp) {
            [self upingAnimation];
        }else{
            [self downingAnimation];
        }
    } completion:^(BOOL finished) {
        self.gViewModel.animationStatus = WVRPlayerToolVStatusAnimationComplete;
    }]; 
}

- (void)downingAnimation
{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
        make.top.mas_equalTo(SCREEN_HEIGHT-HEIGHT_TOP_VIEW_DEFAULT);
//        make.height.mas_equalTo(HEIGHT_TOP_VIEW_DEFAULT);
        //        make.bottom.equalTo(self).offset([self.dataSource heightForTopView]-self.height);
//        make.width.mas_equalTo(100);
    }];
    [self.superview layoutIfNeeded];
//    self.frame = CGRectMake(0, self.superview.height-HEIGHT_BOTTOM_VIEW_DEFAULT, 100, HEIGHT_BOTTOM_VIEW_DEFAULT);
}

- (void)upingAnimation
{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self);
        make.top.mas_equalTo(0);
        //        make.height.mas_equalTo(HEIGHT_TOP_VIEW_DEFAULT);
        //        make.bottom.equalTo(self).offset([self.dataSource heightForTopView]-self.height);
        //        make.width.mas_equalTo(100);
    }];
    [self.superview layoutIfNeeded];
    //    self.frame = CGRectMake(0, self.superview.height-HEIGHT_BOTTOM_VIEW_DEFAULT, 100, HEIGHT_BOTTOM_VIEW_DEFAULT);
}

-(BOOL)playerUINotAutoHide
{
    return YES;
}

-(BOOL)playerUINotAutoShow
{
    return YES;
}
@end
