//
//  WVRGetUserInfoUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGetUserInfoUseCase.h"
#import "WVRApiHttpGetUserInfo.h"
#import "WVRHttpUserInfoReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpUserModel.h"
//#import "WVRLotteryModel.h"


@interface WVRGetUserInfoUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRGetUserInfoUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpGetUserInfo alloc] init];
}

- (WVRRefreshTokenUseCase *)gRefreshTokenUC
{
    if (!_gRefreshTokenUC) {
        _gRefreshTokenUC = [[WVRRefreshTokenUseCase alloc] init];
    }
    return _gRefreshTokenUC;
}

- (RACSignal *)buildUseCase {
    @weakify(self);
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
      
        return value;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        NSString * code = value.content[@"code"];
        @strongify(self);
        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:self.getRequestCmd];
    }] doNext:^(WVRNetworkingResponse *   _Nullable x) {
         WVRHttpUserModel * userModel = [self.requestApi fetchDataWithReformer:[[WVRHttpUserInfoReformer alloc] init]];
        [WVRUserModel sharedInstance].QQisBinded = (userModel.qq.length > 0);
        [WVRUserModel sharedInstance].WBisBinded = (userModel.wb.length > 0);
        [WVRUserModel sharedInstance].WXisBinded = (userModel.wx.length > 0);
        
        if (userModel.nickname)
            [WVRUserModel sharedInstance].username = userModel.nickname;
        if (userModel.heliosid || userModel.account_id)
            [WVRUserModel sharedInstance].accountId = userModel.heliosid.length > 0 ? userModel.heliosid : userModel.account_id;
        if (userModel.accesstoken)
            [WVRUserModel sharedInstance].sessionId = userModel.accesstoken;
        if (userModel.accesstoken)
            [WVRUserModel sharedInstance].expiration_time = userModel.expiretime;
        if (userModel.refreshtoken)
            [WVRUserModel sharedInstance].refreshtoken = userModel.refreshtoken;
        if (userModel.mobile)
            [WVRUserModel sharedInstance].mobileNumber = userModel.mobile;
        if (userModel.avatar)
            [WVRUserModel sharedInstance].loginAvatar = userModel.avatar;
//        [WVRLotteryModel requestForAuthLottery:^(id responseObj, NSError *error) {}];
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

// WVRUseCaseProtocol delegate
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        params = @{
                   kHttpParams_userInfo_device_id:[WVRUserModel sharedInstance].deviceId,
                   kHttpParams_userInfo_accesstoken:[WVRUserModel sharedInstance].sessionId
                   };
    }
    return params;
}
@end
