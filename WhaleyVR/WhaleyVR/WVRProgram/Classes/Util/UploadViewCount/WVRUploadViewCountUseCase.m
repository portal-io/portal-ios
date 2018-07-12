//
//  WVRUploadViewCountUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUploadViewCountUseCase.h"
#import "WVRHttpUploadViewCount.h"
#import "WVRErrorViewModel.h"

@implementation WVRUploadViewCountUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpUploadViewCount alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return nil;
    }] doNext:^(id  _Nullable x) {
        
    }];
    
}

- (RACSignal *)buildErrorCase {
    
    return [self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return nil;
    }];
}

#pragma mark - WVRUseCaseProtocol delegate

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"srcCode"] = self.srcCode;
        dict[@"programType"] = self.programType;
        dict[@"videoType"] = self.videoType;
        dict[@"type"] = self.type;
        dict[@"sec"] = self.sec;
        dict[@"title"] = self.title;
        
        params = dict;
    }
    return params;
}

- (RACCommand *)requestCmd {
    
    return self.requestApi.requestCmd;
}

@end
