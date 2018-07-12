//
//  WVRPayMethodUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayMethodUseCase.h"
#import "WVRHttpPayMethod.h"
#import "WVRErrorViewModel.h"
#import "WVRPayGoodsType.h"

#define kIOSPurchaseType @"40582FD9679C057B"

@implementation WVRPayMethodUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpPayMethod alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        @strongify(self);
        self.isRequesting = NO;
        NSArray *result = [self dealWithResponse:value];
        
        return result;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    @weakify(self);
    return [[self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        @strongify(self);
        self.isRequesting = NO;
        NSArray *result = [self dealWithResponse:nil];  // 请求失败，返回缓存数据
        
        return result;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{ @"appSystem": @"ios" }];
    dict[@"appVerion"] = kAppVersion;
    
    return dict;
}

- (NSArray *)dealWithResponse:(WVRNetworkingResponse *)response {
    
    NSDictionary *dic = response.content;
    
    int code = [dic[@"code"] intValue];
    NSArray *result = nil;
    if (code == 200) {
        
        NSDictionary *dict = dic[@"data"];
        NSMutableArray *typeList = [NSMutableArray arrayWithCapacity:4];
        
        // 因为App已经去掉了支付宝和微信的SDK，所以支付方式也要过滤掉，防止界面操作异常
        if (self.requestForSwitch) {
            if ([dict[@"alipay"] boolValue]) {
                [typeList addObject:@(WVRPayMethodAlipay)];
            }
            if ([dict[@"weixin"] boolValue]) {
                [typeList addObject:@(WVRPayMethodWeixin)];
            }
        }
        // 苹果内购支付
        if ([dict[@"appStore"] boolValue]) {
            [typeList addObject:@(WVRPayMethodAppStore)];
        }
        // 鲸币购买节目
        if ([dict[@"whaleyCurrency"] boolValue]) {
            [typeList addObject:@(WVRPayMethodWhaleyCurrency)];
        }
        
        if (!self.requestForSwitch) {
            
            [[NSUserDefaults standardUserDefaults] setObject:typeList forKey:kIOSPurchaseType];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        result = typeList;
        
    } else {
        NSArray *methodList = [[NSUserDefaults standardUserDefaults] objectForKey:kIOSPurchaseType];
        if (![methodList isKindOfClass:[NSArray class]] || methodList.count == 0) {
            methodList = nil;
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kIOSPurchaseType];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (!methodList) {
            methodList = @[ @(WVRPayMethodAppStore) ];
        }
        result = methodList;
    }
    
    return result;
}

@end
