//
//  WVRUnExchangeCodeModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 用户未兑换的兑换码列表

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WVRRedeemCodeShowType) {
    
    WVRRedeemCodeShowTypePhone = 1,
    WVRRedeemCodeShowTypeActivity
};

@interface WVRRedeemCodeListItemModel : NSObject

/// 兑换码状态 （1：未兑换；0：已兑换）
@property (nonatomic, assign) int  status;
/// 兑换码生成时间
@property (nonatomic, assign) long createTime;
/// 兑换码
@property (nonatomic, copy  ) NSString *redeemCode;
/// 兑换码展示类型（reservationNumber：预留号码关联；activity：活动关联）
@property (nonatomic, copy) NSString *redeemCodeShowType;

/// 兑换码展示类型 enum
@property (nonatomic, readonly) WVRRedeemCodeShowType showType;

@end


@interface WVRUnExchangeCodeModel : NSObject

/// 用户id
@property (nonatomic, copy) NSString *uid;
/// 用户手机号
@property (nonatomic, copy) NSString *phoneNum;
/// 未兑换的兑换码列表
@property (nonatomic, strong) NSArray<WVRRedeemCodeListItemModel *>  *redeemCodeList;


/// 用户未兑换的兑换码列表接口
+ (void)requestUnExchangeRedeemCode:(void (^)(WVRUnExchangeCodeModel *model, NSError *error))block;


@end
