//
//  WVRMineCommonCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTableViewCellViewModel.h"

@interface WVRMineCommonCellViewModel : WVRTableViewCellViewModel
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSString * goinIcon;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subTitle;

@property (nonatomic, assign) BOOL rewardDotHidden;
@property (nonatomic, assign) BOOL bLineHidden;

@end
