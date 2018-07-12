//
//  WVRLiveCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRLiveItemModel;

@interface WVRLiveCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRLiveItemModel* itemModel;

@end


@interface WVRLiveCell : SQBaseCollectionViewCell

@end
