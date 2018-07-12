//
//  WVRMineSplitCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineSplitCellViewModel.h"
#import "WVRSettingViewHeader.h"

@implementation WVRMineSplitCellViewModel

-(instancetype)initWithParams:(id)args
{
    self = [super initWithParams:args];
    if (self) {
        self.cellClassName = UI_NAME_MINE_SPLIT_CELL;
        self.cellHeight = wvr_fitToWidth(10.f);
        
    }
    return self;
}

@end
