//
//  WVRPlayerViewFullS.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerViewFullS.h"

#import "WVRPlayerLeftView.h"
#import "WVRPlayerRightView.h"
#import "WVRPlayerSmallBottomView.h"
#import "WVRPlayerFullSBottomView.h"
#import "WVRPlayerTopView.h"

@interface WVRPlayerViewFullS ()

@property (nonatomic, weak) UIView * gTopView;

@property (nonatomic, weak) UIView * gBottomView;

@property (nonatomic, weak) UIView * gLeftView;

@property (nonatomic, weak) UIView * gRightView;

@end


@implementation WVRPlayerViewFullS
@synthesize gViewModel = _gViewModel;

- (void)fillData:(WVRPlayViewViewModel *)args {
    
    _gViewModel = args;
    @weakify(self);
    [[RACObserve(self.gViewModel, playStatus) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self scheduleHideControls];
    }];
}

- (void)reloadData {
    
    [super reloadData];
}

- (void)loadSubViews {
    [super loadSubViews];
    [self.gTopView removeFromSuperview];
    [self.gBottomView removeFromSuperview];
    [self.gLeftView removeFromSuperview];
    [self.gRightView removeFromSuperview];
    
    UIView * topView = [self.dataSource topViewForPlayerView:self];
    [self insertSubview:topView atIndex:0];
    self.gTopView = topView;
    
    UIView * bottomView = [self.dataSource bottomViewForPlayerView:self];
    [self insertSubview:bottomView atIndex:0];
    self.gBottomView = bottomView;
    
    UIView * leftView = [self.dataSource leftViewForPlayerView:self];
    [self insertSubview:leftView atIndex:0];
    self.gLeftView = leftView;
    
    UIView * rightView = [self.dataSource rightViewForPlayerView:self];
    [self insertSubview:rightView atIndex:0];
    self.gRightView = rightView;
   
}

- (void)createLayout {
    [super createLayout];
    [self.gTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_LEADING_TOP_VIEW);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo([self.dataSource heightForTopView]);
    }];
    [self.gBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_LEADING_TOP_VIEW);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo([self.dataSource heightForBottomView]);
    }];
    [self.gLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.gTopView.mas_bottom);
        make.bottom.equalTo(self.gBottomView.mas_top);
        make.width.mas_equalTo([self.dataSource widthForLeftView]);
    }];
    [self.gRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.gTopView.mas_bottom);
        make.bottom.equalTo(self.gBottomView.mas_top);
        make.width.mas_equalTo([self.dataSource widthForRightView]);
    }];
    
}

@end
