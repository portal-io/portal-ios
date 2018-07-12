//
//  WVRAllChannelCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRItemModel;

@interface WVRAllChannelCellInfo : SQCollectionViewCellInfo

@property (nonatomic, strong) WVRItemModel * itemModel;

@end
@interface WVRAllChannelCell : SQBaseCollectionViewCell

@end
