//
//  WVRBaseEmptyView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseEmptyView.h"
#import "WVRBaseNullView.h"
#import "WVRBaseErrorView.h"
#import <WVRAppDefine.h>

@interface WVRBaseEmptyView ()

@property (nonatomic, strong) WVRBaseNullView* gNullView;
@property (nonatomic, strong) WVRBaseErrorView* gErrorView;

@end


@implementation WVRBaseEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gNullView.frame = self.bounds;
    self.gErrorView.frame = self.bounds;
}

- (WVRBaseNullView *)gNullView {
    if (!_gNullView) {
        _gNullView = [[WVRBaseNullView alloc] initWithFrame:self.frame];
        [self addSubview:self.gNullView];
    }
    return _gNullView;
}

- (WVRBaseErrorView  *)gErrorView {
    if (!_gErrorView) {
        _gErrorView = [[WVRBaseErrorView alloc] initWithFrame:self.frame];
        [self addSubview:self.gErrorView];
    }
    return _gErrorView;
}

- (void)showNullViewWithTitle:(NSString *)title icon:(NSString *)icon withreloadBlock:(void (^)(void))reloadBlock{

    self.gErrorView.hidden = YES;
    self.gNullView.hidden = NO;
    self.hidden = NO;
    if (title) {
        [self.gNullView setContentText:title];
    }
    if (icon) {
        [self.gNullView setIcon:icon];
    }
    kWeakSelf(self);
    [self.gNullView setTryBlock:^{
        weakself.hidden = YES;
        reloadBlock();
    }];
}

- (void)showNetErrorVWithreloadBlock:(void(^)(void))reloadBlock {
    
    self.gErrorView.hidden = NO;
    self.gNullView.hidden = YES;
    self.hidden = NO;
    kWeakSelf(self);
    [self.gErrorView setTryBlock:^{
        
        weakself.hidden = YES;
        reloadBlock();
    }];
}

@end
