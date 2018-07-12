//
//  WVRSQBannerReusableHeader.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRBannerModel.h"

typedef NS_ENUM(NSInteger, WVRBannerHeaderType) {
    WVRBannerHeaderTypeDefault,
    WVRBannerHeaderTypeAD,
};

@interface WVRSQBannerReusableHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic, copy) void(^onClickItemBlock)(NSInteger);
@property (nonatomic, copy) void(^updateAutoScroll)(BOOL);
@property (nonatomic) WVRBannerHeaderType type;
@property (nonatomic) NSArray<WVRBannerModel*>* bannerModels;

@end


@interface WVRSQBannerReusableHeader : SQBaseCollectionReusableHeader

@end
