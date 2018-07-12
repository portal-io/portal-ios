//
//  WVRPayBIModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayBIModel.h"
#import "WVRPayModel.h"

@implementation WVRPayBIModel

+ (void)trackEventForPayWithAction:(BIPayActionType)action payModel:(WVRPayModel *)payModel fromVC:(UIViewController *)fromVC {
    
    if (payModel.payComeFromType != WVRPayComeFromTypeWCurrency && (payModel.goodsCode.length == 0 || payModel.relatedType.length == 0)) {
        DDLogError(@"error: trackEventForPayWithAction relatedCode == nil");
        return;
    }
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"payDetails";
    model.logInfo.nextPageId = model.logInfo.currentPageId;
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    if (action == BIPayActionTypeSuccess) {
        
        model.logInfo.eventId = @"pay_success";
    } else {
        
        model.logInfo.eventId = @"order_form";
    }
    
    NSString *voucherType = payModel.relatedType ?: payModel.goodsType;
    
    DDLogInfo(@"trackEventForPayWithAction: %@, code = %@, type = %@", model.logInfo.eventId, payModel.goodsCode, voucherType);
    
    currentPageProp[@"relatedCode"] = payModel.goodsCode;
    currentPageProp[@"voucherType"] = voucherType;
    
//    currentPageProp[@"isUnity"] = (nil == fromVC) ? @1 : @0;
    
//    if (payModel.payComeFromType == WVRPayComeFromTypeProgramLive) {
//
//        if (payModel.liveStatus == WVRLiveStatusNotStart) {
//
//            currentPageProp[@"fromType"] = @"livePrevue";
//        } else {
//            currentPageProp[@"fromType"] = @"live";
//        }
//    } else if (payModel.payComeFromType == WVRPayComeFromTypeProgramPackage) {
//
//        currentPageProp[@"fromType"] = @"content_packge";
//    } else {
//
//        currentPageProp[@"fromType"] = @"recorded";
//    }
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

//+ (void)trackEventForExchange:(WVRPayBIModel *)biModel {
//    
//    WVRBIModel *model = [[WVRBIModel alloc] init];
//    model.logInfo.currentPageId = @"convertDetail";
//    model.logInfo.eventId = @"convert";
//    model.logInfo.nextPageId = model.logInfo.currentPageId;
//    
//    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
//    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
//    
//    eventProp[@"eventType"] = biModel.eventType;
//    eventProp[@"eventID"] = biModel.eventID;
//    
//    model.logInfo.eventProp = eventProp;
//    model.logInfo.currentPageProp = currentPageProp;
//    
//    [model saveToSQLite];
//}

+ (void)trackEventForExchangeSuccess:(NSString *)relatedCode relatedType:(NSString *)relatedType {
    
    if (relatedCode.length == 0 || relatedType.length == 0) {
        DDLogError(@"error: trackEventForExchangeSuccess relatedCode == nil");
        return;
    }
    
    DDLogInfo(@"trackEventForExchangeSuccess: code = %@, type = %@", relatedCode, relatedType);
    
    WVRBIModel *model = [[WVRBIModel alloc] init];
    model.logInfo.currentPageId = @"convertDetail";
    
    model.logInfo.eventId = @"convert";
    model.logInfo.nextPageId = @"convertDetail";
    
    NSMutableDictionary *currentPageProp = [NSMutableDictionary dictionary];
    NSMutableDictionary *eventProp = [NSMutableDictionary dictionary];
    
    eventProp[@"eventType"] = relatedType;
    eventProp[@"eventID"] = relatedCode;
    
    model.logInfo.eventProp = eventProp;
    model.logInfo.currentPageProp = currentPageProp;
    
    [model saveToSQLite];
}

@end
