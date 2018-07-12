//
//  WVRPayManager.h
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPayModel.h"

typedef NS_ENUM(NSInteger, WVRPayManageResultStatus) {
    
    WVRPayManageResultStatusUN,
    WVRPayManageResultStatusSuccess,    // 之前已支付 也回调成功
    WVRPayManageResultStatusFail,
    WVRPayManageResultStatusCancle,
    WVRPayManageResultStatusNotHavePay,
    WVRPayManageResultStatusOverTime,
};

@interface WVRPayManager : NSObject

+ (instancetype)shareInstance;

+ (NSString *)messageForStatus:(WVRPayManageResultStatus)status;

/**
 调起支付窗口并进行支付流程

 @param payModel 数据模型
 @param viewController 当前VC，可传nil
 @param callback 回调block
 */
- (void)showPayAlertViewWithPayModel:(WVRPayModel *)payModel viewController:(UIViewController *)viewController resultCallback:(void(^)(WVRPayManageResultStatus status))callback;

@end
