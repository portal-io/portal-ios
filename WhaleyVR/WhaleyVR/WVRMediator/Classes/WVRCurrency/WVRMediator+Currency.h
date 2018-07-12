//
//  WVRMediator+Account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (Currency)

- (UIViewController *)WVRMediator_CurrencyConfigViewController;

- (void)WVRMediator_GetUserWCBalance;

/**
 鲸币购买付费节目
 
 @param params @{ @"ticketCode":NSString, @"ticketName":NSString, @"cmd":RACCommend }
 */
- (void)WVRMediator_BuyWithWhaleyCurrency:(NSDictionary *)params;

@end
