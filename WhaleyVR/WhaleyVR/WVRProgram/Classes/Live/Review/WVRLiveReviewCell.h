//
//  WVRLiveReviewCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRItemModel;

@interface WVRLiveReviewCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRItemModel * itemModel;
@property (nonatomic) CGFloat margin;

@end
@interface WVRLiveReviewCell : SQBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIView *topV;
@end
