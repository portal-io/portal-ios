//
//  WVRLiveShowPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveShowPresenter.h"
#import "WVRShowFieldView.h"

@interface WVRLiveShowPresenter ()

@property (nonatomic) WVRShowFieldView * mShowView;

@property (nonatomic) NSString * createArgs;
@end

@implementation WVRLiveShowPresenter

+ (instancetype)createPresenter:(id)createArgs
{
    WVRLiveShowPresenter * presenter = [[WVRLiveShowPresenter alloc] init];
    presenter.createArgs = createArgs;
    [presenter loadSubViews];
    return presenter;
}

- (void)loadSubViews {
    if (!self.mShowView) {
        self.mShowView = [WVRShowFieldView createWithFrame:CGRectZero info:@{@"posId":self.createArgs}];
    }
}

-(void)reloadData
{
    [self.mShowView refreshData];
}

-(UIView *)getView
{
    return self.mShowView;
}

@end
