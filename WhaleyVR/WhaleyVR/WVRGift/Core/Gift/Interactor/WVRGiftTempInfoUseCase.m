//
//  WVRGiftTempInfoUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftTempInfoUseCase.h"
#import "WVRHttpGiftTempInfo.h"
#import "WVRErrorViewModel.h"
#import "WVRGiftTempInfoReformer.h"

@implementation WVRGiftTempInfoUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRHttpGiftTempInfo alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSArray* result = [self.requestApi fetchDataWithReformer:[[WVRGiftTempInfoReformer alloc] init]];
        return result;
    }]  doNext:^(id  _Nullable x) {
        
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
                              kHttpParams_giftTempInfo_Code : self.tempCode,
                              kHttpParams_giftTempInfo_pageNum : self.pageNum,
                              kHttpParams_giftTempInfo_pageSize : self.pageSize
                              
                              };
    return params;
}
@end
