//
//  WVRLiveReserveHeader.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRRewardSectionHeader.h"

@interface WVRRewardSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property WVRRewardSectionHeaderInfo *cellInfo;
@end
@implementation WVRRewardSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleL.textColor = k_Color7;
    self.titleL.font = [UIFont systemFontOfSize:fitToWidth(12.f)];
//    self.backgroundColor = [UIColor whiteColor];
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRRewardSectionHeaderInfo*)info;
    if (self.cellInfo.title.length>0) {
        self.titleL.text = [NSString stringWithFormat:@"%@月",self.cellInfo.title];
    }
}
@end
@implementation WVRRewardSectionHeaderInfo

@end
