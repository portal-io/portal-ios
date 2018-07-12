//
//  WVRHttpCurrencyCost.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币消费接口

#import <WVRAPIBaseManager.h>

UIKIT_EXTERN NSString * const kHttpParam_currencyCost_uid ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_nickName ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_userHeadUrl ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_buyType ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_buyParams ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_bizParams ;
UIKIT_EXTERN NSString * const kHttpParam_currencyCost_sign ;

@interface WVRHttpCurrencyCost : WVRAPIBaseManager<WVRAPIManager>

@end
