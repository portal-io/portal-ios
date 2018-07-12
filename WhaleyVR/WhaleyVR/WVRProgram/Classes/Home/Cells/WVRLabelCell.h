//
//  WVRLabelCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRItemModel;

@interface WVRLabelCellInfo : SQCollectionViewCellInfo

@property (nonatomic, weak) WVRItemModel * itemModel;

@end

@interface WVRLabelCell : SQBaseCollectionViewCell


@end
