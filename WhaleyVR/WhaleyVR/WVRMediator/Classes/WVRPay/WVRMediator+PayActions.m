//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+PayActions.h"

NSString * const kWVRMediatorTargetPay = @"pay";

NSString * const kWVRMediatorActionNativeFetchMyTicketViewController = @"nativeFetchMyTicketViewController";

NSString * const kWVRMediatorActionNativePayForVideo = @"nativePayForVideo";

NSString * const kWVRMediatorActionNativePayForWCurrency = @"nativePayForWCurrency";

NSString * const kWVRMediatorActionNativeCheckVideoIsPaied = @"nativeCheckIsPaied";

NSString * const kWVRMediatorActionNativeCheckVideosIsPaied = @"nativeCheckVideosIsPaied";

NSString * const kWVRMediatorActionNativeCheckDevice = @"nativeCheckDevice";

NSString * const kWVRMediatorActionNativePayReportDevice = @"nativePayReportDevice";

NSString * const kWVRMediatorActionNativeReportLostInAppPurchaseOrders = @"nativeReportLostInAppPurchaseOrders";

@implementation WVRMediator (PayActions)

- (UIViewController *)WVRMediator_MyTicketViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetPay
                                                    action:kWVRMediatorActionNativeFetchMyTicketViewController
                                                    params:@{@"key":@"value"}
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

- (void)WVRMediator_PayForVideo:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativePayForVideo
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_PayForWCurrency:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativePayForWCurrency
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_CheckVideoIsPaied:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativeCheckVideoIsPaied
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_CheckVideosIsPaied:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativeCheckVideosIsPaied
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_PayReportDevice:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativePayReportDevice
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_CheckDevice:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativeCheckDevice
                 params:params
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_ReportLostInAppPurchaseOrders {
    
    [self performTarget:kWVRMediatorTargetPay
                 action:kWVRMediatorActionNativeReportLostInAppPurchaseOrders
                 params:@{@"key":@"value"}
      shouldCacheTarget:NO
     ];
}

@end
