//
//  WVRLiveRecommendBannerCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRItemModel;

@interface WVRLiveRecommendBannerCellInfo : SQCollectionViewCellInfo

@property (nonatomic,weak) UIViewController * controller;
@property (nonatomic) NSArray<WVRItemModel*>* itemModels;
@property (nonatomic) BOOL haveLoaded;

@end


@interface WVRLiveRecommendBannerCell : SQBaseCollectionViewCell

@end
