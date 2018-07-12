//
//  WVRApiHttpPayCallback.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager+ReactiveExtension.h"

extern NSString * const kHttpParam_PayCallback_orderNo;
extern NSString * const kHttpParam_PayCallback_payMethod;
extern NSString * const kHttpParam_PayCallback_sign; //MD5(orderNo+payMethod+key)


@interface WVRApiHttpPayCallback : WVRAPIBaseManager <WVRAPIManager>

@end
