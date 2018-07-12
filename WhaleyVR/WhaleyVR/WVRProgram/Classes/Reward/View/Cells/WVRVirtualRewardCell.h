//
//  WVRVirtualRewardCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/19.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "WVRRewardModel.h"

@interface WVRVirtualRewardCellInfo : SQTableViewCellInfo

@property (nonatomic) WVRRewardModel * rewardModel;
@property (nonatomic,copy) void(^copyBlock)(void);

@end
@interface WVRVirtualRewardCell : SQBaseTableViewCell

@end
