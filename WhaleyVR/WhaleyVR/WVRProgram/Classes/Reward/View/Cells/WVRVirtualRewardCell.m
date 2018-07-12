//
//  WVRVirtualRewardCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/19.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRVirtualRewardCell.h"

@interface WVRVirtualRewardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (nonatomic) WVRVirtualRewardCellInfo * cellInfo;
- (IBAction)copyBtnOnClick:(id)sender;

@end
@implementation WVRVirtualRewardCell

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRVirtualRewardCellInfo*)info;
    self.titleL.text = [NSString stringWithFormat:@"%@我抽中了",self.cellInfo.rewardModel.formatDateStr];
    self.subTitleL.text = self.cellInfo.rewardModel.title;
    self.codeL.text = self.cellInfo.rewardModel.rewardInfo;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.rewardModel.thubImageStr] placeholderImage:HOLDER_IMAGE];
}

- (IBAction)copyBtnOnClick:(id)sender {
    if (self.cellInfo.copyBlock) {
        self.cellInfo.copyBlock();
    }
}
@end
@implementation WVRVirtualRewardCellInfo

@end
