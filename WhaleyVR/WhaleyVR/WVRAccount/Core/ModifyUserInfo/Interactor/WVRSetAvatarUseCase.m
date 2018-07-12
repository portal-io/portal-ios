//
//  WVRSetAvatarUseCase.m
//  WVRAccount
//
//  Created by qbshen on 2017/9/13.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "WVRSetAvatarUseCase.h"
#import "WVRApiHttpSetAvatar.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpUserModel.h"

@interface WVRSetAvatarUseCase ()


@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end
@implementation WVRSetAvatarUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpSetAvatar alloc] init];
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
    }] doNext:^(WVRNetworkingResponse *   _Nullable value) {
        NSString * msg = value.content[@"msg"];
        self.gResponseMsg = msg;
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
                   Params_setAvatar_accesstoken:[WVRUserModel sharedInstance].sessionId,
                   kBSFileUploadParams_formData:self.fileData,
                   kBSFileUploadParams_keyName:self.keyName,
                   kBSFileUploadParams_fileName:self.fileName
                   };
    }
    return params;
}
@end
