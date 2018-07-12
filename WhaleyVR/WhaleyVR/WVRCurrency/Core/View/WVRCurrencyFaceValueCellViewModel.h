//
//  WVRCurrencyFaceValueCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@class WVRCurrencyBuyConfigItemModel;

@interface WVRCurrencyFaceValueCellViewModel : SQTableViewCellInfo

@property (nonatomic, strong) WVRCurrencyBuyConfigItemModel * configModel;

@end
