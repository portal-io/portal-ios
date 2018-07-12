//
//  WVRTVVideoDetailUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVVideoDetailUseCase.h"
#import "WVRApiHttpVideoDetail.h"
#import "WVRTVVideoDetailReformer.h"
#import "WVRTVItemModel.h"

@implementation WVRTVVideoDetailUseCase

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRTVItemModel * model = [self.requestApi fetchDataWithReformer:[[WVRTVVideoDetailReformer alloc] init]];
        return model;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

-(NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager
{
    return @{kHttpParams_videoDetail_code:self.code,
             kHttpParams_videoDetail_uid:[WVRUserModel sharedInstance].accountId};
}

@end
