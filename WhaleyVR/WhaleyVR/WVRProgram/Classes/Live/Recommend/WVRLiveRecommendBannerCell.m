//
//  WVRLiveRecommendBannerCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendBannerCell.h"
#import "WVRLiveRecommendBannerPresenter.h"

@interface WVRLiveRecommendBannerCell ()

@property (nonatomic) WVRLiveRecommendBannerPresenter * mRBP;

@end
@implementation WVRLiveRecommendBannerCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.mRBP) {
        self.mRBP = [WVRLiveRecommendBannerPresenter createPresenter:nil];
    }
    UIView * view = [self.mRBP getView];
    [self addSubview:view];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRLiveRecommendBannerCellInfo * cellInfo = (WVRLiveRecommendBannerCellInfo*)info;
    if (cellInfo.haveLoaded) {
        return;
    }
    cellInfo.haveLoaded = YES;
    [self.mRBP setFrameForView:self.bounds];
    self.mRBP.itemModels = cellInfo.itemModels;
    [self.mRBP fetchData];
}

-(void)dealloc
{
    DDLogInfo(@"dealloc");
}
@end

@implementation WVRLiveRecommendBannerCellInfo

@end
