//
//  WVRContentPackageQueryDto.h
//  WhaleyVR
//
//  Created by Bruce on 2017/4/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 合集/节目包

typedef NS_ENUM(NSInteger, WVRPackageType) {
    
    WVRPackageTypeProgramSet,               // 合集
    WVRPackageTypeProgramPackage,           // 节目包
};

@interface WVRCouponDto :NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *relatedCode;
@property (nonatomic, copy) NSString *relatedType;
@property (nonatomic, copy) NSString *descriptionStr;

/// 鲸币价格
@property (nonatomic, strong) NSNumber *jingbiPrice;

/// 折扣价格
@property (nonatomic, copy) NSString *discountPrice;

/// 券价格，若discountPrice 有值则返回折扣价格
@property (nonatomic, assign) long price;

@property (nonatomic, assign) int type;

@end


@interface WVRContentPackageQueryDto : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, assign) long price;                   // getter已经重写
@property (nonatomic, strong) WVRCouponDto *couponDto;

@property (nonatomic, strong) NSString * detailCount;

@property (nonatomic, strong) NSString * totalCount;

@property (nonatomic, assign) int  payType;
@property (nonatomic, assign) int  isChargeable;

/// "type" //包类型(1:支持单个收费和包收费；0：包独立收费)
@property (nonatomic, copy) NSString  *type;

/// 节目包 or 合集 (使用时必须先判断self是否存在！！！)
- (WVRPackageType)packageType;

@end
