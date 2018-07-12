//
//  WVRVideoDetailInfoUseCase.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRVideoDetailInfoUseCase.h"
#import "WVRHttpApiVideoDetailInfo.h"

#import "WVRErrorViewModel.h"
#import "WVRPayGoodsType.h"

@implementation WVRVideoDetailInfoUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpApiVideoDetailInfo alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value.content;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    return [[self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value.content[@"msg"];
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    return self.params;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    ((WVRHttpApiVideoDetailInfo *)self.requestApi).urlMethodName = urlString;
}

- (void)dealRequestResult {
    
}

@end
