//
//  WVRApiHttpSmsToken.m
//  WhaleyVR
//
//  Created by XIN on 21/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpSmsToken.h"
#import "WVRNetworkingAccountService.h"
#import "WVRHttpSMSTokenModel.h"

NSString * const Params_smsToken_device_id = @"device_id";

@interface WVRApiHttpSmsToken () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpSmsToken

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/sms/gettoken.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    WVRHttpSMSTokenModel *tokenModel = [WVRHttpSMSTokenModel yy_modelWithDictionary:[response.content valueForKey:@"data"]];
    [WVRUserModel sharedInstance].sms_token = tokenModel.sms_token;
    self.successedBlock(tokenModel);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end
