//
//  WVRCurrencyDetailTitleViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface WVRCurrencyDetailTitleViewModel : SQTableViewCellInfo

@property (nonatomic , assign) NSInteger              totalNum;
@property (nonatomic , assign) NSInteger              priceAmount;
@property (nonatomic , assign) NSInteger              whaleyCurrencyAmount;
@end
