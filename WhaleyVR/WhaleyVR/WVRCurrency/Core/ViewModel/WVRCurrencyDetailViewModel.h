//
//  WVRCurrencyDetailViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@class WVRTableViewAdapter;

@interface WVRCurrencyDetailViewModel : WVRViewModel

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

@property (nonatomic, assign, readonly) BOOL isEmpty;

@property (nonatomic, strong) RACCommand * gGotoWCDescrCmd;

@property (nonatomic, strong, readonly) WVRTableViewAdapter * gTableViewAdapter;

- (RACCommand *)getCurrencyOrderListCmd;

@end
