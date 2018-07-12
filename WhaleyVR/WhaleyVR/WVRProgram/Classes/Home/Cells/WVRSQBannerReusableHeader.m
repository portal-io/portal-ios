//
//  WVRSQBannerReusableHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQBannerReusableHeader.h"
#import "SQBannerView.h"
#import "WVRSQFindUIStyleHeader.h"
//#import "WVRLayoutConstraintTool.h"

@interface WVRSQBannerReusableHeader ()

@property (nonatomic) SQBannerView* bannerView;
@property (nonatomic) WVRSQBannerReusableHeaderInfo * cellInfo;

@end


@implementation WVRSQBannerReusableHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
#pragma mark - 适配宽度不固定
    self.bannerView = [[SQBannerView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.bannerView];
//    [WVRLayoutConstraintTool addTBLRViewCont:self.bannerView inSec:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bannerView.bounds = CGRectMake(0, 0, self.width, self.height);
    self.bannerView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    if (self.cellInfo == info) {
        return;
    }
    self.cellInfo = (WVRSQBannerReusableHeaderInfo *)info;
    if (self.cellInfo.type == WVRBannerHeaderTypeAD) {
        [self.bannerView updateWithData:[self parseImageUrls] titles:nil localImageNames:nil];
    } else {
        [self.bannerView updateWithData:[self parseImageUrls] titles:[self parseImageTitles] localImageNames:nil];
    }
    kWeakSelf(self);
    self.bannerView.onClickItemBlock = ^(NSInteger index) {
        if (weakself.cellInfo.onClickItemBlock) {
            weakself.cellInfo.onClickItemBlock(index);
        }
    };
    self.cellInfo.updateAutoScroll = self.bannerView.updateAutoScroll;
}

- (NSArray *)parseImageUrls
{
    NSMutableArray* arr = [NSMutableArray array];
    for (WVRBannerModel* model in self.cellInfo.bannerModels) {
        [arr addObject:model.videoModel.thubImage];
    }
    return arr;
}

- (NSArray *)parseImageTitles
{
    NSMutableArray* arr = [NSMutableArray array];
    for (WVRBannerModel* model in self.cellInfo.bannerModels) {
        [arr addObject:model.videoModel.name];
    }
    return arr;
}

@end


@implementation WVRSQBannerReusableHeaderInfo

@end
