//
//  WVRPlayerViewLive.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerViewLive.h"

#import "WVRLiveAlertView.h"
#import "WVRLiveInfoAlertView.h"
#import "WVRLiveRemindChargeView.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "WVRPlayerUIFrameMacro.h"

@interface WVRPlayerViewLive ()

//@property (nonatomic, weak) UIButton *liveBackBtn;
//@property (nonatomic, weak) WVRLiveTitleView *liveTitleView;      // 有点击事件

//@property (nonatomic, weak) WVRLiveRemindChargeView *liveRemindChargeView;

@property (nonatomic, weak) UIView * gTopView;

@property (nonatomic, weak) UIView * gBottomView;

@property (nonatomic, weak) UIView * gGiftContainerView;

@end


@implementation WVRPlayerViewLive
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
    [self.gGiftContainerView removeFromSuperview];
    
    UIView * topView = [self.dataSource topViewForPlayerView:self];
    if (topView) {
        [self addSubview:topView];
    }
    self.gTopView = topView;
    UIView * bottomView = [self.dataSource bottomViewForPlayerView:self];
    if (bottomView) {
        [self addSubview:bottomView];
    }
    self.gBottomView = bottomView;
    UIView * giftContainerView = [self.dataSource giftContainerViewForPlayerView:self];
    if (giftContainerView) {
        [self addSubview:giftContainerView];
    }
    self.gGiftContainerView = giftContainerView;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.gTopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_LEADING_TOP_VIEW);
    }];
    [self.gBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_LEADING_TOP_VIEW);
    }];
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
    CGFloat offset = (SCREEN_WIDTH<SCREEN_HEIGHT)&kDevice_Is_iPhoneX? (kTabBarHeight-49.f):0;
    [self.gGiftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-offset);
        make.top.equalTo(self);
    }];
}

#pragma mark - overWrite func

- (void)setDelegate:(id)delegate {
    [super setDelegate:delegate];
    
    self.liveDelegate = delegate;
}

- (void)drawUI {
    [super drawUI];
    
//    [self.loadingView startAnimating:NO];
}

- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration {
    
    [self controlsShowHideAnimation:NO];
    
//    [self.loadingView stopAnimating];
}

// 支付成功
- (void)execPaymentSuccess {
    
//    [self.remindChargeLabel removeFromSuperview];
//    [_liveRemindChargeView removeFromSuperview];
}

#pragma mark - getter

//- (WVRLiveRemindChargeView *)liveRemindChargeView {
//
//    if (!_liveRemindChargeView) {
//        WVRLiveRemindChargeView *view = [[WVRLiveRemindChargeView alloc] initWithPrice:[[self ve][@"price"] integerValue] endTime:[[self ve][@"endTime"] integerValue]];
//        view.centerX = self.width * 0.5f;
//        view.centerY = self.height * 0.5f;
//
//        [self addSubview:view];
//        _liveRemindChargeView = view;
//    }
//    return _liveRemindChargeView;
//}

#pragma mark - live

- (void)execNetworkStatusChanged {
    
    // TODO: - network status changed
    
}

- (void)execLotteryResult:(NSDictionary *)dict {
    
    int status = [dict[@"status"] intValue];
    if (status < 0) {
        [SQToastTool showErrorMessageForSnailVRAPI:status];
    } else if (status == 1) {
        NSDictionary *award = dict[@"prizedata"];
        [WVRLiveAlertView showWithImage:award[@"picture"] title:award[@"name"] lotteryTime:[dict[@"countdown"] intValue] delegate:self.liveDelegate];
    } else {
        [WVRLiveAlertView showWithLotteryTime:[dict[@"countdown"] intValue]];
    }
}

@end
