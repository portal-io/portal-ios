//
//  WVRMyReserveCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@class WVRLiveItemModel;

@interface WVRMyReserveCellInfo : SQTableViewCellInfo

@property (nonatomic) WVRLiveItemModel * itemModel;

@end
@interface WVRMyReserveCell : SQBaseTableViewCell

@end
