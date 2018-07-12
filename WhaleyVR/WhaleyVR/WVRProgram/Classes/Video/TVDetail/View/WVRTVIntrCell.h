//
//  WVRTVIntrCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRItemModel.h"

@interface WVRTVIntrCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRItemModel * itemModel;

@end
@interface WVRTVIntrCell : SQBaseCollectionViewCell

@end
