//
//  WVRCurrencyBuyConfigListModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "code": "20170718105332427fa81cbf2bbfa438",//配置code
 "whaleyCurrencyNumber": 100,//充值鲸币数
 "whaleyCurrencyGiveNumber": 10,//赠送鲸币数
 "whaleyCurrencyAmount": 110,//总鲸币数
 "price": 100,//价格
 "preferPrice": 60//优惠价格

 */
@interface WVRCurrencyBuyConfigItemModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, assign) NSInteger whaleyCurrencyNumber;
@property (nonatomic, assign)  NSInteger whaleyCurrencyGiveNumber;
@property (nonatomic, assign) NSInteger whaleyCurrencyAmount;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger preferPrice;

@end


@interface WVRCurrencyBuyConfigListModel : NSObject

@property (nonatomic, strong) NSArray<WVRCurrencyBuyConfigItemModel*>* list;

@end
