//
//  WVRPayGoodsType.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRPayGoodsType_h
#define WVRPayGoodsType_h


/// "1":"仅开启苹果内购"; "2":"仅开启微信、支付宝"; "3":"开启苹果内购、微信、支付宝"

typedef NS_ENUM(NSInteger, IOSPurchaseType) {
    
    IOSPurchaseTypeAppIn = 1,
    IOSPurchaseTypeAliWechat = 2,
    IOSPurchaseTypeAll = 3,
};

/// 支付方式

typedef NS_ENUM(NSInteger, WVRPayMethod) {
    
    WVRPayMethodWhaleyCurrency,         // 0
    WVRPayMethodWeixin,                 // 1
    WVRPayMethodAlipay,                 // 2
    WVRPayMethodAppStore,               // 3
};

/// 要弹出的Alert/ActionSheet的展示类型

typedef NS_ENUM(NSInteger, OrderAlertType) {
    
    OrderAlertTypeResultSuccess,       // success
    OrderAlertTypePayment,             // to pay
    OrderAlertTypeResultFailed,        // retry
};

/*
 pay 1310
 unionPay 11
 alixPay 12
 weixinPay 13
 applePay 61
 qqPay 25
 inApplePurchase 60
 baiduPay 50
 */
typedef NS_ENUM(NSInteger, WVRPayPlatform) {    // 对应 ipaynow 的支付平台序号
    
    WVRPayPlatformWhaleyCurrency = -2,          // 鲸币，v3.4新增
    WVRPayPlatformAppIn = -1,                   // Apple 内购
    WVRPayPlatformUN = 0,                       // 未知，异常状态
    WVRPayPlatformAlipay = 12,                  // 支付宝
    WVRPayPlatformWeixin = 13,                  // 微信支付
};

#endif /* WVRPayGoodsType_h */
