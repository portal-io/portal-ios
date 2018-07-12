//
//  WVRApiHttpCreateOrder.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager+ReactiveExtension.h"

extern NSString * const kHttpParam_CreateOrder_uid;
extern NSString * const kHttpParam_CreateOrder_goodsNo;
extern NSString * const kHttpParam_CreateOrder_goodsType;
extern NSString * const kHttpParam_CreateOrder_price;
extern NSString * const kHttpParam_CreateOrder_payMethod ;
extern NSString * const kHttpParam_CreateOrder_sign; // MD5(uid+goodsNo+goodsName+goodType+price+key)


@interface WVRApiHttpCreateOrder : WVRAPIBaseManager <WVRAPIManager>

@end
