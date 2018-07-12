//
//  WVRThirtyPLoginUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRThirtyPLoginUseCase.h"
#import "WVRApiHttpThirdPartyLogin.h"
#import "WVRModelUserInfoReformer.h"
#import "WVRModelUserInfo.h"
//#import "UnityAppController+JPush.h"
#import "WVRErrorViewModel.h"
#import "WVRThirtyPAuthUseCase.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WVRThirtyPLoginModel.h"

@interface WVRThirtyPLoginUseCase ()
@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * unionId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) WVRThirtyPAuthUseCase * gThirtyPAuthUC;
@end


@implementation WVRThirtyPLoginUseCase

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

- (void)setUpRAC
{
    RAC(self, openId) = RACObserve(self.gThirtyPAuthUC, openId);
    RAC(self, unionId) = RACObserve(self.gThirtyPAuthUC, unionId);
    RAC(self, nickName) = RACObserve(self.gThirtyPAuthUC, nickName);
    RAC(self, avatar) = RACObserve(self.gThirtyPAuthUC, avatar);
    RAC(self.gThirtyPAuthUC, origin) = RACObserve(self, origin);
    @weakify(self);
    [[self.gThirtyPAuthUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.requestApi.requestCmd execute:nil];
    }];
}

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpThirdPartyLogin alloc] init];
}

- (WVRThirtyPAuthUseCase *)gThirtyPAuthUC
{
    if (!_gThirtyPAuthUC) {
        _gThirtyPAuthUC = [[WVRThirtyPAuthUseCase alloc] init];
    }
    return _gThirtyPAuthUC;
}

- (RACCommand *)getRequestCmd
{
    return [self.gThirtyPAuthUC getRequestCmd];
}

- (RACSignal *)buildUseCase {
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRModelUserInfo* modelUserInfo = [self.requestApi fetchDataWithReformer:[[WVRModelUserInfoReformer alloc] init]];
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"144"]) {
            @strongify(self);
            WVRThirtyPLoginModel * model = [[WVRThirtyPLoginModel alloc] init];
            model.msg = value.content[@"msg"];
            model.openId = self.openId;
            model.avatar = self.avatar;
            model.nickName = self.nickName;
            model.unionId = self.unionId;
            model.thirdId = modelUserInfo.third_id;
            model.origin = [self mappinghttpPlatformType:self.origin];
            return model;
        } else if([code isEqualToString:@"000"]) {
            return modelUserInfo;
        } else {
            return value;
        }
    }]  doNext:^(id _Nullable x) {
        if ([x isKindOfClass:[WVRThirtyPLoginModel class]]) {
            
        } else if ([x isKindOfClass:[WVRModelUserInfo class]]) {
            @strongify(self);
            WVRModelUserInfo* modelUserInfo = x;
            if (modelUserInfo.username)
                [WVRUserModel sharedInstance].username = modelUserInfo.username;
            if (modelUserInfo.heliosid || modelUserInfo.account_id)
                [WVRUserModel sharedInstance].accountId = modelUserInfo.heliosid.length > 0 ? modelUserInfo.heliosid : modelUserInfo.account_id;
            if (modelUserInfo.accesstoken)
                [WVRUserModel sharedInstance].sessionId = modelUserInfo.accesstoken;
            if (modelUserInfo.expiretime)
                [WVRUserModel sharedInstance].expiration_time = modelUserInfo.expiretime;
            if (modelUserInfo.refreshtoken)
                [WVRUserModel sharedInstance].refreshtoken = modelUserInfo.refreshtoken;
            if (modelUserInfo.mobile)
                [WVRUserModel sharedInstance].mobileNumber = modelUserInfo.mobile;
            if (modelUserInfo.avatar)
                [WVRUserModel sharedInstance].loginAvatar = modelUserInfo.avatar;
            [WVRUserModel sharedInstance].isLogined = YES;
            [WVRUserModel sharedInstance].firstLogin = YES;
//            UnityAppController* app = (UnityAppController *)[UIApplication sharedApplication].delegate;
//            [app setTagsAlias];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:self userInfo:@{ @"status" : @1 }];
        }
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (manager == self.requestApi) {
        params[Params_thirdPartyLogin_origin] = [self mappinghttpPlatformType:self.origin];
        params[Params_thirdPartyLogin_from] = @"whaleyVR";
        params[Params_thirdPartyLogin_device_id] = [WVRUserModel sharedInstance].deviceId;
        params[Params_thirdPartyLogin_open_id] = self.openId;
        params[Params_thirdPartyLogin_unionid] = self.unionId;
        params[Params_thirdPartyLogin_nickname] = self.nickName;
        params[Params_thirdPartyLogin_avatar] = self.avatar;
    }
    return params;
}

- (NSString*)mappinghttpPlatformType:(UMSocialPlatformType)platformType{
    NSDictionary* dic = @{
                          @(QQ_btn_tag):@"qq",
                          @(WB_btn_tag):@"wb",
                          @(WX_btn_tag):@"wx"};
    NSString * str = dic[@(platformType)];
    return str;
}

@end
