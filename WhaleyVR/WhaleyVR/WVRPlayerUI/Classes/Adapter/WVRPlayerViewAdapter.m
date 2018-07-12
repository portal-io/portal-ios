//
//  WVRPlayerViewAdapter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerViewAdapter.h"
#import "WVRPlayViewCellViewModel.h"
#import "WVRPlayViewCell.h"
#import "WVRPlayerView.h"

@interface WVRPlayerViewAdapter ()

@end


@implementation WVRPlayerViewAdapter

//- (void)loadData:(NSDictionary *(^)(void))loadDataBlock {
- (void)loadData:(NSDictionary *)dict {
    _gOriginDic = dict;
}


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

- (UIView *)leftViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kLEFT_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

- (UIView *)rightViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kRIGHT_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)loadingViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kLOADING_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)centerViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kCENTER_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)backAnimationViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kCHANGETOVRMODE_ANIMATION_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

-(UIView *)giftContainerViewForPlayerView:(WVRPlayerView *)playerView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kGIFTCONTAINER_PLAYVIEW];
    WVRPlayViewCell *cell = [self cellForSection:viewModel playView:playerView];
    [cell fillData:viewModel];
    return cell;
}

- (CGFloat)heightForTopView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kTOP_PLAYVIEW];
    return viewModel.height;
}

- (CGFloat)heightForBottomView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kBOTTOM_PLAYVIEW];
    return viewModel.height;
}

- (CGFloat)widthForLeftView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kLEFT_PLAYVIEW];
    return viewModel.width;
}

- (CGFloat)widthForRightView
{
    WVRPlayViewCellViewModel * viewModel = self.gOriginDic[kRIGHT_PLAYVIEW];
    return viewModel.width;
}

#pragma mark - private

- (WVRPlayViewCell *)cellForSection:(WVRPlayViewCellViewModel *)viewModel playView:(WVRPlayerView *)playView {
    
    WVRPlayViewCell* cell ;
    NSString * nibName = viewModel.cellNibName;
    NSString * className = viewModel.cellClassName;
    if (nibName) {//是否需要单独定义reuseIdentifier功能
        cell = [playView dequeueReusableCellWithIdentifier:nibName];
        if (!cell) {
            DebugLog(@"创建新的PlayViewCell");
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
            if ([nib count]>0)
                [playView registerNib:[nib objectAtIndex:0] forCellReuseIdentifier:nibName];
            cell = [playView dequeueReusableCellWithIdentifier:nibName];
        }
    } else if(className)
    {
        cell = [playView dequeueReusableCellWithIdentifier:className];
        if (!cell) {
            cell = [[NSClassFromString(className) alloc] init];
        }
    } else {
        WVRPlayViewCell * cur = [[WVRPlayViewCell alloc] init];
        cur.userInteractionEnabled = NO;
        return cur;
    }
    return cell;
}

@end
