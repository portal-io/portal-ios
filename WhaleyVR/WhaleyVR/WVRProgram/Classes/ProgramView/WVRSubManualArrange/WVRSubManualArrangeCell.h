//
//  WVRSubManualArrangeCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSubManualArrangeCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRItemModel * itemModel;

@property (nonatomic, assign) CGFloat gTop;
@property (nonatomic, assign) CGFloat gBottom;

@property (nonatomic, copy) void(^playBlock)(void);
@property (nonatomic, copy) void(^gotoDetailBlock)(void);

@end
@interface WVRSubManualArrangeCell : SQBaseCollectionViewCell

@end
