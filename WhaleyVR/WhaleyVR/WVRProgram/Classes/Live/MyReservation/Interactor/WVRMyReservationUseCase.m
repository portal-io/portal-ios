//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReservationUseCase.h"
#import "WVRApiHttpMyReservation.h"
#import "WVRMyReservationReformer.h"
#import "WVRErrorViewModel.h"

@implementation WVRMyReservationUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpMyReservation alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSArray<WVRItemModel*>* result = [self.requestApi fetchDataWithReformer:[[WVRMyReservationReformer alloc] init]];
        return result;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        return YES;
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
    return @{
             kHttpParams_myReserveList_uid:[WVRUserModel sharedInstance].accountId,
             kHttpParams_myReserveList_token:[WVRUserModel sharedInstance].sessionId,
             kHttpParams_myReserveList_device_id:[WVRUserModel sharedInstance].deviceId
             };
}
@end
