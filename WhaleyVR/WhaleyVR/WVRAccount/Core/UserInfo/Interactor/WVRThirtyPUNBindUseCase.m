//
//  WVRThirtyPBindUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRThirtyPUNBindUseCase.h"
#import "WVRThirtyPAuthUseCase.h"
#import "WVRApiHttpUnBindThirdParty.h"
#import "WVRErrorViewModel.h"
#import <UMSocialCore/UMSocialCore.h>


@interface WVRThirtyPUNBindUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRThirtyPUNBindUseCase

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
    self.requestApi = [[WVRApiHttpUnBindThirdParty alloc] init];
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
                   Params_thirdPartyUNBind_origin:[self mappinghttpPlatformType:self.origin],
                   Params_thirdPartyUNBind_device_id:[WVRUserModel sharedInstance].deviceId,
                   Params_thirdPartyUNBind_accesstoken:[WVRUserModel sharedInstance].sessionId
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


