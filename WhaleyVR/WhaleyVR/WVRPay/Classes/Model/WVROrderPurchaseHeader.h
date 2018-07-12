//
//  WVROrderPurchaseHeader.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVROrderPurchaseHeader_h
#define WVROrderPurchaseHeader_h

/// 支付状态类型

typedef NS_ENUM(NSInteger, MyOrderStatus) {
    
    MyOrderStatusFail,          // 支付失败
    MyOrderStatusPaid,          // 已支付
    MyOrderStatusNotPay,        // 未支付
    MyOrderStatusUnkonw,        // 第三方未回调
};

/// 券来源

typedef NS_ENUM(NSInteger, CouponSourceType) {
    
    CouponSourceTypeOrder = 1,
    CouponSourceTypeRedeemCode,
};

/// 购买节目上架/下架状态

typedef NS_ENUM(NSInteger, MerchandiseStatus) {
    
    MerchandiseStatusOffline = 0,       // 已下架 0
    MerchandiseStatusOnline = 1,        // 未下架 1
};

#endif /* WVROrderPurchaseHeader_h */
