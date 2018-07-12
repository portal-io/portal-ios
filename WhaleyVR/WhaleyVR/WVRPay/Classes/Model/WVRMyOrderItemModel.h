//
//  WVRMyOrderItemModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "WVRUIConst.h"
#import "WVRAPIConst.h"
#import "WVRNetConst.h"
#import "WVROrderPurchaseHeader.h"
@class WVRMyOrderListModel;

//goodsType	商品类型（live：直播；recorded：录播；content_packge：节目包；coupon：券；）

UIKIT_EXTERN NSString * const GOODS_TYPE_LIVE;
UIKIT_EXTERN NSString * const GOODS_TYPE_RECORD;
UIKIT_EXTERN NSString * const GOODS_TYPE_CONTENT_PACKGE;
UIKIT_EXTERN NSString * const GOODS_TYPE_COUPON;     // 暂时未用到
UIKIT_EXTERN NSString * const GOODS_TYPE_WHALEYCURRENCY ;

@interface WVRMyOrderItemModel : NSObject

/// 商品类型
@property (nonatomic, copy) NSString *merchandiseType;

/// 商品编码
@property (nonatomic, copy) NSString *merchandiseCode;
@property (nonatomic, copy) NSString *merchandiseName;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *orderId;               // 订单号
@property (nonatomic, copy) NSString *merchandiseImage;
@property (nonatomic, copy) NSString *currency;              // 商品货币类型
@property (nonatomic, assign) MyOrderStatus result;
@property (nonatomic, assign) long updateTime;
@property (nonatomic, assign) MerchandiseStatus merchandiseStatus;         // 是否已下架（未下架：1；已下架：0）
@property (nonatomic, assign) long merchandiseContentCount;  // 节目包的节目总数
@property (nonatomic, assign) WVRLiveStatus liveStatus;

@property (nonatomic, assign) long merchandisePrice;

/// 商品价格（单位分）
@property (nonatomic, assign) long amount;

- (PurchaseProgramType)purchaseType;

+ (PurchaseProgramType)purchaseTypeForGoodType:(NSString *)goodsType;

+ (NSString *)goodsTypeForPurchaseType:(PurchaseProgramType)purchaseType;

+ (void)requestForMyOrderListWithPage:(int)page pageSize:(int)pageSize block:(void (^)(WVRMyOrderListModel *model, NSError *error))block;

// 用户付费节目播放设备是否匹配
+ (void)requestForDeviceCheck:(void (^)(BOOL signSuccess))block;

// 用户付费节目播放设备上报
+ (void)requestForReportPlayDevice:(void (^)(BOOL success))block;

// 商品是否已购买接口(第三方支付)
+ (void)requestForQueryProgramCharged:(NSString *)goodsNo goodsType:(PurchaseProgramType)goodsType block:(void (^)(BOOL isCharged, NSError *error))block;

@end


@interface WVRMyOrderListModel : NSObject

@property (nonatomic, assign) long total;
@property (nonatomic, assign) long size;
@property (nonatomic, assign) long number;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) long totalElements;
@property (nonatomic, assign) long totalPages;
@property (nonatomic, assign) long numberOfElements;

@property (nonatomic, strong) NSArray<WVRMyOrderItemModel *> *content;

@end

