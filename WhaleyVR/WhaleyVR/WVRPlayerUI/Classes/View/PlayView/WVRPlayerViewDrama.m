//
//  WVRPlayerViewDrama.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerViewDrama.h"

@interface WVRPlayerViewDrama ()

@property (nonatomic, weak) UIView * gDramaCenterView;

@end

@implementation WVRPlayerViewDrama

-(void)loadSubViews
{
    [super loadSubViews];
    [self.gDramaCenterView removeFromSuperview];
    UIView * centerView = [self.dataSource centerViewForPlayerView:self];
    [self insertSubview:centerView atIndex:0];
    self.gDramaCenterView = centerView;
}

-(void)createLayout
{
    [super createLayout];
    [self.gDramaCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TOP_VIEW_DEFAULT);
        make.bottom.equalTo(self).offset(-HEIGHT_TOP_VIEW_DEFAULT);
        make.left.equalTo(self).offset(LEFT_LEADING_TOP_VIEW);
    }];
}

@end
