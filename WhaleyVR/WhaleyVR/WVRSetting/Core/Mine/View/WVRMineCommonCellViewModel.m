//
//  WVRMineCommonCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineCommonCellViewModel.h"
#import "WVRSettingViewHeader.h"

@implementation WVRMineCommonCellViewModel

-(instancetype)initWithParams:(id)args
{
    self = [super initWithParams:args];
    
    if (self) {
        self.args = args;
        self.cellClassName = UI_NAME_MINE_COMMON_CELL;
        self.cellHeight = wvr_fitToWidth(58.5f);
        self.rewardDotHidden = YES;
        self.bLineHidden = YES;
        self.goinIcon = @"icon_find_MA_goto";
    }
    return self;
}
@end
