//
//  WVRLiveRecSubBannerCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecReBannerCell.h"
#import "WVRLiveRecReBannerPresenter.h"

@interface WVRLiveRecReBannerCell ()

@property (nonatomic) WVRLiveRecReBannerPresenter * mRBP;

@end
@implementation WVRLiveRecReBannerCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.mRBP) {
        self.mRBP = [WVRLiveRecReBannerPresenter createPresenter:nil];
    }
    UIView * view = [self.mRBP getView];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(fitToWidth(10.f));
        make.bottom.equalTo(self);
        make.right.mas_equalTo(fitToWidth(10.f));
    }];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRLiveRecReBannerCellInfo* cellInfo = (WVRLiveRecReBannerCellInfo*)info;
//    [self.mRBP setFrameForView:CGRectMake(fitToWidth(10.f), 0, self.width-fitToWidth(10.f)*2, self.height)];
    self.mRBP.itemModel = cellInfo.itemModel;
    [self.mRBP reloadData];
}


@end

@implementation WVRLiveRecReBannerCellInfo

@end
