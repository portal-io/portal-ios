//
//  WVRCurrencyDetailItemViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@class WVRCurrencyOrderListItem;

@interface WVRCurrencyDetailItemViewModel : SQTableViewCellInfo

@property (nonatomic, strong) WVRCurrencyOrderListItem * orderItem;

@end
