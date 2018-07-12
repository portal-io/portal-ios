//
//  WVRRewardCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRRewardCell.h"

@interface WVRRewardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;

@property (nonatomic) WVRRewardCellInfo * cellInfo;

@end


@implementation WVRRewardCell

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    self.cellInfo = (WVRRewardCellInfo *)info;
    self.titleL.text = [NSString stringWithFormat:@"%@我抽中了", self.cellInfo.rewardModel.formatDateStr];
    self.subTitleL.text = self.cellInfo.rewardModel.title;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.rewardModel.thubImageStr] placeholderImage:HOLDER_IMAGE];
}

@end


@implementation WVRRewardCellInfo

@end
