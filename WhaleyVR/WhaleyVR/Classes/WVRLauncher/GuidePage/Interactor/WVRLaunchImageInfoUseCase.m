//
//  WVRLaunchImageInfoUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLaunchImageInfoUseCase.h"
#import "WVRHttpLaunchImageInfo.h"
#import "WVRErrorViewModel.h"
#import "WVRRecommendItemModel.h"

@implementation WVRLaunchImageInfoUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpLaunchImageInfo alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        @strongify(self);
        NSArray *result = [self dealWithResponse:value];
        
        return result;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    return [[self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    return [NSDictionary dictionary];
}

// WVRRecommndAreaType
- (NSArray *)dealWithResponse:(WVRNetworkingResponse *)response {
    
    NSDictionary *dic = response.content;
    NSDictionary *data = dic[@"data"];
    NSArray *recommendAreas = data[@"recommendAreas"];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    for (NSDictionary *recommend in recommendAreas) {
        
//        NSDictionary *recommend = [recommendAreas firstObject];
        NSArray *recommendElements = recommend[@"recommendElements"];
        NSDictionary *element = [recommendElements firstObject];
        
        WVRRecommendItemModel *result = [WVRRecommendItemModel yy_modelWithDictionary:element];
        result.recommendAreaType = [recommend[@"type"] integerValue];
        if (result) {
            [resultArr addObject:result];
        }
    }
    
    return resultArr;
}

@end
