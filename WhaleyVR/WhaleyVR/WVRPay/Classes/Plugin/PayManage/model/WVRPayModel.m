//
//  WVRPayModel.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayModel.h"
#import <WVRAppContextHeader.h>
#import <UIView+Extend.h>

@interface WVRPayModel ()<NSCopying> {
    
    NSNumber *_tmpPayGoodsType;
}

@end


@implementation WVRPayModel
@synthesize goodsType = _goodsType;

- (instancetype)init {
    self = [super init];
    if (self) {
        _userId = [WVRUserModel sharedInstance].accountId;
        // 当前产品只能购买券
        _goodsType = GOODS_TYPE_COUPON;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    
    WVRPayModel *p = [[WVRPayModel alloc] init];
    
    p.fromType = self.fromType;
    p.payPlatform = self.payPlatform;
    p.payComeFromType = self.payComeFromType;
    p.userId = self.userId;
    p.goodsCode = self.goodsCode;
    p.goodsName = self.goodsName;
    p.relatedCode = self.relatedCode;
    p.relatedType = self.relatedType;
    p.liveStatus = self.liveStatus;
    p.goodsPrice = self.goodsPrice;
    p.disableTime = self.disableTime;
    p.packageType = self.packageType;
    p.defaultGoodsType = self.defaultGoodsType;
    p.programPackModel = self.programPackModel;
    p.originPrice = self.originPrice;
    p.prePrice = self.prePrice;
    p.jingbiPrice = self.jingbiPrice;
    p.giveWCurrency = self.giveWCurrency;
    
    return p;
}

-(NSString *)goodsType
{
    switch (self.payComeFromType) {
        case WVRPayComeFromTypeWCurrency:
            _goodsType = GOODS_TYPE_WHALEYCURRENCY;
            break;
            
        default:
            _goodsType = GOODS_TYPE_COUPON;
            break;
    }
    return _goodsType;
}

- (PurchaseProgramType)purchaseType {
    
    return [WVRMyOrderItemModel purchaseTypeForGoodType:_goodsType];
}

- (WVRPayGoodsType)payGoodsType {
    
    if (!_tmpPayGoodsType) {
        
        WVRPayGoodsType type = [self checkGoodsType];
        _tmpPayGoodsType = @(type);
    }
    return _tmpPayGoodsType.integerValue;
}

- (BOOL)isProgramAndPackage {
    
    if ([self payGoodsType] == WVRPayGoodsTypeProgramAndPackage) {
        
        return YES;
    }
    return NO;
}

+ (instancetype)createWithDetailModel:(WVRItemModel *)detailBaseModel streamType:(WVRStreamType)streamType {
    
    WVRPayModel *payModel = [[WVRPayModel alloc] init];
    
    payModel.fromType = PayFromTypeApp;
    payModel.goodsCode = detailBaseModel.couponDto.code;
    payModel.goodsPrice = detailBaseModel.couponDto.price;
    payModel.jingbiPrice = detailBaseModel.couponDto.jingbiPrice;
    payModel.goodsName = detailBaseModel.couponDto.displayName;
    payModel.relatedCode = detailBaseModel.couponDto.relatedCode;
    payModel.relatedType = detailBaseModel.couponDto.relatedType;
    payModel.disableTime = detailBaseModel.disableTimeDate;
    
    if ([detailBaseModel.programType isEqualToString:PROGRAMTYPE_LIVE]) {
        payModel.payComeFromType = WVRPayComeFromTypeProgramLive;
        payModel.liveStatus = detailBaseModel.liveStatus;
    } else if ([detailBaseModel.programType isEqualToString:PROGRAMTYPE_RECORDED]) {
        payModel.payComeFromType = WVRPayComeFromTypeProgramRecord;
    } else {
        payModel.payComeFromType = WVRPayComeFromTypeProgramPackage;
    }
    
    WVRContentPackageQueryDto *packageDto = detailBaseModel.contentPackageQueryDtos.firstObject;
    
    payModel.programPackModel = packageDto;
    payModel.packageType = [detailBaseModel.contentPackageQueryDto packageType];
    
    return payModel;
}

+ (instancetype)createWithDict:(NSDictionary *)dict {
    
    NSDictionary *contentPackageQueryDto = [dict[@"contentPackageQueryDtos"] firstObject];
    WVRContentPackageQueryDto *packageDto = [WVRContentPackageQueryDto yy_modelWithDictionary:contentPackageQueryDto];
    
    NSDictionary *couponDict = dict[@"couponDto"];
    WVRCouponDto *couponDto = [WVRCouponDto yy_modelWithDictionary:couponDict];
    
    NSString *programType = couponDto.relatedType;
    
    WVRPayModel *payModel = [[WVRPayModel alloc] init];
    
    payModel.goodsCode = couponDto.code;
    payModel.goodsPrice = couponDto.price;
    payModel.goodsName = couponDto.displayName;
    payModel.relatedCode = [NSString stringWithFormat:@"%@", dict[@"code"]];
    payModel.relatedType = couponDto.relatedType;
    payModel.disableTime = [dict[@"disableTimeDate"] integerValue];
    
    if ([programType isEqualToString:GOODS_TYPE_LIVE]) {
        payModel.payComeFromType = WVRPayComeFromTypeProgramLive;
        payModel.liveStatus = [dict[@"liveStatus"] intValue];
    } else if ([programType isEqualToString:GOODS_TYPE_RECORD]) {
        payModel.payComeFromType = WVRPayComeFromTypeProgramRecord;
    } else if ([programType isEqualToString:GOODS_TYPE_CONTENT_PACKGE]) {
        payModel.payComeFromType = WVRPayComeFromTypeProgramPackage;
    }
    
    NSLog(@"programType == %@", programType);
    
    payModel.programPackModel = packageDto;
    
    return payModel;
}

//one step 判断是直播还是点播，直播直接购买节目包，点播判断点播详情price是否大于0，等于0直接购买节目包，大于0用户选择是购买节目包还是当前节目。

- (WVRPayGoodsType)checkGoodsType {
    
    WVRPayGoodsType packageGoodsType = [self checkIsPackageGoodsType];
    WVRPayGoodsType programGoodsType = [self checkIsProgramGoodsType];
    
    WVRPayGoodsType finalType = WVRPayGoodsTypeProgram;
    
    if (packageGoodsType == WVRPayGoodsTypeProgramPackage) {
        if (programGoodsType == WVRPayGoodsTypeProgram) {
            finalType = WVRPayGoodsTypeProgramAndPackage;
        } else {
            finalType = WVRPayGoodsTypeProgramPackage;
        }
    } else {
        if (programGoodsType == WVRPayGoodsTypeProgram) {
            finalType = WVRPayGoodsTypeProgram;
        } else {
            finalType = WVRPayGoodsTypeFree;
        }
    }
    
    if (finalType == WVRPayGoodsTypeProgramPackage && self.programPackModel != nil) {
        
        self.goodsCode = self.programPackModel.couponDto.code;
        self.goodsPrice = self.programPackModel.couponDto.price;
        self.goodsName = self.programPackModel.couponDto.displayName;
        self.relatedCode = self.programPackModel.couponDto.relatedCode;
        self.relatedType = self.programPackModel.couponDto.relatedType;
        self.jingbiPrice = self.programPackModel.couponDto.jingbiPrice;
        
        self.programPackModel = nil;
    }
    
    return finalType;
}

- (WVRPayGoodsType)checkIsPackageGoodsType {
    
    if ([self.programPackModel.couponDto.relatedType isEqualToString:GOODS_TYPE_CONTENT_PACKGE]) {
        if ([self.programPackModel price] > 0) {
            DDLogInfo(@"节目包付费");
            
            return WVRPayGoodsTypeProgramPackage;
        }
    } else {
        if ([self.relatedType isEqualToString:GOODS_TYPE_CONTENT_PACKGE] && self.goodsPrice > 0) {
            DDLogInfo(@"节目包付费");
            
            return WVRPayGoodsTypeProgramPackage;
        }
    }
    DDLogInfo(@"节目包不需要付费");
    return WVRPayGoodsTypeFree;
}

- (WVRPayGoodsType)checkIsProgramGoodsType {
    
    // 节目包单独收费
    if (self.programPackModel && [self.programPackModel packageType] == WVRPackageTypeProgramSet) {
        DDLogInfo(@"节目包单独收费, 节目无法单独购买");
        return WVRPayGoodsTypeFree;
    }
    
    if (self.goodsPrice > 0 && ![self.relatedType isEqualToString:GOODS_TYPE_CONTENT_PACKGE]) {
        DDLogInfo(@"节目付费");
        return WVRPayGoodsTypeProgram;
    }
    
    DDLogInfo(@"节目不需要付费");
    return WVRPayGoodsTypeFree;
}

@end
