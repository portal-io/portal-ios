//
//  WVRApiHttpCheckPay.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager+ReactiveExtension.h"

UIKIT_EXTERN NSString * const kHttpParam_checkPay_uid ;
UIKIT_EXTERN NSString * const kHttpParam_checkPay_goodsNo ;
UIKIT_EXTERN NSString * const kHttpParam_checkPay_goodsType ;
UIKIT_EXTERN NSString * const kHttpParam_checkPay_sign ;

@interface WVRApiHttpCheckPay : WVRAPIBaseManager <WVRAPIManager>

@end
