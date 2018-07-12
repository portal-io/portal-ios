//
//  WVRLiveRBannerCCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRItemModel;

@interface WVRLiveRBannerCCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRItemModel * itemModel;

@end
@interface WVRLiveRBannerCCell : SQBaseCollectionViewCell
-(void)updateAnimalBig;
-(void)updateAnimalSmall;
@end
