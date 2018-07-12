//
//  WVRSQFindArrangeCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRVideoModel.h"

@interface WVRSQFindArrangeCellInfo : SQCollectionViewCellInfo
@property (nonatomic) WVRVideoModel* videoModel;
@end
@interface WVRSQFindArrangeCell : SQBaseCollectionViewCell

@end
