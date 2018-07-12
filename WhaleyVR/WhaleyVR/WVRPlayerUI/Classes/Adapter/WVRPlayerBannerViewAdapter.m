//
//  WVRPlayerBannerViewAdapter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBannerViewAdapter.h"
#import "WVRPlayViewCell.h"
#import "WVRPlayViewCellViewModel.h"

@implementation WVRPlayerBannerViewAdapter

- (WVRPlayViewCell *)topViewForPlayerView:(WVRPlayerView *)playerView {
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kTOP_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

- (WVRPlayViewCell *)bottomViewForPlayerView:(WVRPlayerView *)playerView {
    
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kBOTTOM_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)leftViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kLEFT_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)rightViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kRIGHT_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(CGFloat)heightForTopView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kTOP_PLAYVIEW];
    return viewModel.height;
}

-(CGFloat)heightForBottomView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kBOTTOM_PLAYVIEW];
    return viewModel.height;
}

-(CGFloat)widthForLeftView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kLEFT_PLAYVIEW];
    return viewModel.width;
}

- (CGFloat)widthForRightView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kRIGHT_PLAYVIEW];
    return viewModel.width;
}

@end
