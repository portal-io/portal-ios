//
//  WVRRecommendPlayerHeader.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRecommendPlayerHeader.h"
#import "WVRSmallPlayerPresenter.h"

@interface WVRRecommendPlayerHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *playerBottomV;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (nonatomic, weak) WVRRecommendPlayerHeaderInfo * cellInfo;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

- (IBAction)gotoNextOnClick:(id)sender;

@end


@implementation WVRRecommendPlayerHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.playerBottomV addSubview:self.clickBtn];
    self.clickBtn.bounds = self.playerBottomV.bounds;
    self.clickBtn.center = self.playerBottomV.center;
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRRecommendPlayerHeaderInfo * headerInfo = (WVRRecommendPlayerHeaderInfo*)info;
    self.cellInfo = headerInfo;
    if (headerInfo.needRload) {
        headerInfo.needRload = NO;
        [self.bgImageV wvr_setImageWithURL:[NSURL URLWithString:[headerInfo.args logoImageUrl]] placeholderImage:HOLDER_IMAGE];
        [self.playerBottomV wvr_setImageWithURL:[NSURL URLWithString:[headerInfo.args thubImageUrl]] placeholderImage:HOLDER_IMAGE];
        [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
//        [WVRSmallPlayerPresenter shareInstance].controller = headerInfo.controller;
        [[WVRSmallPlayerPresenter shareInstance] responseCurPage:0 itemModel:headerInfo.args contentView:self.playerBottomV];
        kWeakSelf(headerInfo);
        headerInfo.reloadPlayerBlock = ^{
            [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
            [[WVRSmallPlayerPresenter shareInstance] responseCurPage:0 itemModel:weakheaderInfo.args contentView:self.playerBottomV];
        };
    }
}

- (IBAction)gotoNextOnClick:(id)sender {
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}

@end


@implementation WVRRecommendPlayerHeaderInfo

@end
