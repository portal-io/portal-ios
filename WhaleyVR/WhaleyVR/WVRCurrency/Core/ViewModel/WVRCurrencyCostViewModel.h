//
//  WVRCurrencyCostViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRCurrencyCostViewModel : WVRViewModel


@property (nonatomic, copy) NSString *buyParams;//礼物code
@property (nonatomic, copy) NSString *bizParams;//涉及的业务参数（1、直播code；2、直播code+','+直播成员code）

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getCurrencyCostCmd;


@end
