//
//  WVRMyTicketListModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVROrderPurchaseHeader.h"
#import "WVRNetModelHeader.h"
#import "WVRAPIConst.h"

@interface WVRMyTicketItemModel : NSObject

/// 用户id
@property (nonatomic, copy) NSString *uid;
/// 券来源（order:订单；redeemCode:兑换码）
@property (nonatomic, copy) NSString *couponSource;
/// 券编码
@property (nonatomic, copy) NSString *couponCode;
/// 关联内容code
@property (nonatomic, copy) NSString *relatedCode;
/// 关联类型（recorded：节目；live：直播；content_packge：节目包）
@property (nonatomic, copy) NSString *relatedType;
/// 券来源相关编码
@property (nonatomic, copy) NSString *couponSourceCode;
/// 货币类型（RMB：人民币）
@property (nonatomic, copy) NSString *currency;
/// 券名称
@property (nonatomic, copy) NSString *displayName;
/// 价格
@property (nonatomic, assign) long price;
/// 创建时间
@property (nonatomic, assign) long createTime;
/// 直播状态（0：直播前；1：直播中；2：直播后）
@property (nonatomic, assign) WVRLiveStatus liveStatus;
/// 券状态（1：有效；0：失效）
@property (nonatomic, assign) int couponStatus;
/// 券类型（1：观看券）
@property (nonatomic, assign) int couponType;
/// 直播屏幕显示方向（1：横屏; 0:竖屏）
@property (nonatomic, assign) WVRLiveDisplayMode liveDisplayMode;
/// 直播内容类型（live_football 足球直播; live_fun 娱乐直播; live_show 秀场直播）
@property (nonatomic, copy) NSString *liveType;


#pragma mark -  getter
/// 价格 ￥10
@property (nonatomic, readonly) NSString *priceStr;
/// 缓存的cell高度
@property (nonatomic, readonly) float cellHeight;
/// 传值 cell 宽
@property (nonatomic, assign) float cellWidth;

@property (nonatomic, readonly) float nameLabelHeight;
@property (nonatomic, readonly) float nameLabelWidth;

/// 关联类型 enum
- (PurchaseProgramType)purchaseType;
- (CouponSourceType)couponSource_type;

/// priceStr Size
- (CGSize)priceLabelSize;

/// 标题字号
+ (UIFont *)nameLabelFont;

@end


@interface WVRMyTicketListModel : NSObject

@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalElements;
@property (nonatomic, assign) NSInteger numberOfElements;
@property (nonatomic, strong) NSArray<WVRMyTicketItemModel *> *content;

@end
