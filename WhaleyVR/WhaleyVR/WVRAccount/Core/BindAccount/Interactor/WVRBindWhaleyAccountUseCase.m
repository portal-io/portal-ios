//
//  WVRBindWhaleyAccountUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBindWhaleyAccountUseCase.h"
#import "WVRApiHttpBindThirdPary.h"
#import "WVRRefreshTokenUseCase.h"
#import "WVRErrorViewModel.h"
#import <UMSocialCore/UMSocialCore.h>

@interface WVRBindWhaleyAccountUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRBindWhaleyAccountUseCase
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
    
}

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpBindThirdPary alloc] init];
}

-(RACCommand *)getRequestCmd
{
    
    return self.requestApi.requestCmd;
}

-(WVRRefreshTokenUseCase *)gRefreshTokenUC
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
        @strongify(self);
        NSString * code = value.content[@"code"];
        return [self.gRefreshTokenUC filterTokenValide:code
                                              retryCmd:self.getRequestCmd];
    }] doNext:^(id _Nullable x) {
        
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
                   Params_thirdPartyBind_origin:self.origin,
                   Params_thirdPartyBind_device_id:[WVRUserModel sharedInstance].deviceId,
                   Params_thirdPartyBind_open_id:self.openId,
                   Params_thirdPartyBind_unionid:self.unionId,
                   Params_thirdPartyBind_nickname:self.nickName,
                   Params_thirdPartyBind_avatar:self.avatar,
                   Params_thirdPartyBind_accesstoken:[WVRUserModel sharedInstance].sessionId
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
