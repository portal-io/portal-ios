//
//  WVRRewardCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "WVRRewardModel.h"

@interface WVRRewardCellInfo : SQTableViewCellInfo

@property (nonatomic) WVRRewardModel * rewardModel;

@end
@interface WVRRewardCell : SQBaseTableViewCell

@end
