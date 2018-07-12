//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveNoticeUseCase.h"
#import "WVRApiHttpLiveNotice.h"
#import "WVRErrorViewModel.h"
#import "WVRRefreshTokenUseCase.h"
#import "WVRLiveNoticeReformer.h"

@interface WVRLiveNoticeUseCase ()

//@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end
@implementation WVRLiveNoticeUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpLiveNotice alloc] init];
}

//- (WVRRefreshTokenUseCase *)gRefreshTokenUC
//{
//    if (!_gRefreshTokenUC) {
//        _gRefreshTokenUC = [[WVRRefreshTokenUseCase alloc] init];
//    }
//    return _gRefreshTokenUC;
//}


- (RACSignal *)buildUseCase {
//    @weakify(self);
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"152"]) {
            return value;
        }

        NSArray<WVRItemModel*>* result = [self.requestApi fetchDataWithReformer:[[WVRLiveNoticeReformer alloc] init]];
        return result;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        return YES;
//        if (![value isKindOfClass:[WVRNetworkingResponse class]]) {
//            return YES;
//        }
//        NSString * code = value.content[@"code"];
     
//        @strongify(self);
//        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:self.getRequestCmd];
    }] doNext:^(id  _Nullable x) {
        
    }];
    
}

- (RACSignal *)buildErrorCase {
    return [self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }];
}


- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSDictionary * params = @{
                              kHttpParams_liveOrder_uid : [WVRUserModel sharedInstance].accountId,
                              kHttpParams_liveOrder_device_id : [WVRUserModel sharedInstance].deviceId,
                              kHttpParams_liveOrder_token:[WVRUserModel sharedInstance].sessionId,
                              kHttpParams_liveOrder_action:self.action,
                              kHttpParams_liveOrder_code:self.code? self.code:@"",
                              };
    return params;
}
@end
