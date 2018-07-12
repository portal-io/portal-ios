//
//  WVRCoinCertificateModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 兑换码/观看券Model

#import <Foundation/Foundation.h>
@class WVRExchangeTicketDetailModel, WVRRelatedTicketsModel, WVRUnExchangeCodeModel, WVRUserTicketListModel, WVRMyTicketListModel;

@interface WVRExchangeTicketModel : NSObject

/// 用户券订单列表接口
+ (void)requestUserTicketsWithPage:(int)page block:(void (^)(WVRUserTicketListModel *model, NSError *error))block;

@end


@interface WVRExchangeTicketDetailModel : NSObject

@property (nonatomic, copy  ) NSString *descriptionStr;
@property (nonatomic, copy  ) NSString *discount;
@property (nonatomic, copy  ) NSString *relatedType;
@property (nonatomic, copy  ) NSString *relatedCode;
@property (nonatomic, copy  ) NSString *pic;
@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, copy  ) NSString *price;
@property (nonatomic, copy  ) NSString *currency;
@property (nonatomic, copy  ) NSString *displayName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger enableTime;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger disableTime;

@end


@interface WVRRelatedTicketsModel : NSObject

@property (nonatomic, strong) NSArray<WVRExchangeTicketDetailModel *> *packsCoupons;
@property (nonatomic, strong) WVRExchangeTicketDetailModel *myCoupon;

@end
