//
//  WVRThirtyPRegisterUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRThirtyPRegisterUseCase.h"
#import "WVRApiHttpThirdPartyLogin.h"
#import "WVRModelUserInfoReformer.h"
#import "WVRModelUserInfo.h"
//#import "UnityAppController+JPush.h"
#import "WVRErrorViewModel.h"
#import "WVRThirtyPAuthUseCase.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WVRThirtyPLoginModel.h"

@interface WVRThirtyPRegisterUseCase ()

@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * unionId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) WVRThirtyPAuthUseCase * gThirtyPAuthUC;
@end
@implementation WVRThirtyPRegisterUseCase

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(void)setUpRAC
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

-(WVRThirtyPAuthUseCase *)gThirtyPAuthUC
{
    if (!_gThirtyPAuthUC) {
        _gThirtyPAuthUC = [[WVRThirtyPAuthUseCase alloc] init];
        
    }
    return _gThirtyPAuthUC;
}

-(RACCommand *)getRequestCmd
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
        }
        return modelUserInfo;
    }] doNext:^(id _Nullable x) {
        if ([x isKindOfClass:[WVRThirtyPLoginModel class]]) {
            
        }else{
            @strongify(self);
            [WVRUserModel sharedInstance].isLogined = YES;
            [WVRUserModel sharedInstance].firstLogin = YES;
            [WVRUserModel sharedInstance].sessionId = [x accesstoken];
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
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        params = @{
                   Params_thirdPartyLogin_origin:[self mappinghttpPlatformType:self.origin],
                   Params_thirdPartyLogin_from:@"whaleyVR",
                   Params_thirdPartyLogin_device_id:[WVRUserModel sharedInstance].deviceId,
                   Params_thirdPartyLogin_open_id:self.openId,
                   Params_thirdPartyLogin_unionid:self.unionId,
                   Params_thirdPartyLogin_nickname:self.nickName,
                   Params_thirdPartyLogin_avatar:self.avatar
                   };
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
