//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionSaveUseCase.h"
#import "WVRApiHttpCollectionSave.h"
#import "WVRErrorViewModel.h"
#import "WVRRefreshTokenUseCase.h"

@interface WVRCollectionSaveUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end


@implementation WVRCollectionSaveUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpCollectionSave alloc] init];
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
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"152"]) {
            return value;
        }
        if ([code isEqualToString:@"401"]) {
            NSLog(@"auth error");
            return value;
        }
    
        return value;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        if (![value isKindOfClass:[WVRNetworkingResponse class]]) {
            return YES;
        }
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"401"]) {
            NSLog(@"auth error");
            return NO;
        }
        @strongify(self);
        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:self.getRequestCmd];
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

/*
 params[kHttpParams_collectionSave_userLoginId] = [[WVRUserModel sharedInstance] accountId];
 params[kHttpParams_collectionSave_userName] = [[WVRUserModel sharedInstance] username];
 params[kHttpParams_collectionSave_programCode] = tvModel.code;
 params[kHttpParams_collectionSave_programName] = tvModel.name.length > 0 ? tvModel.name:@"name";
 params[kHttpParams_collectionSave_programType] = tvModel.programType.length > 0 ? tvModel.programType:PROGRAMTYPE_MORETV_TV;
 params[kHttpParams_collectionSave_videoType] = [NSString stringWithFormat:@"%@",(long)tvModel.videoType.length > 0 ? tvModel.videoType:@"moretv_2d"];
 params[kHttpParams_collectionSave_status] = @"1";
 params[kHttpParams_collectionSave_duration] = tvModel.duration.length > 0 ? tvModel.duration:@"0";
 params[kHttpParams_collectionSave_picUrl] = tvModel.thubImageUrl.length > 0 ? tvModel.thubImageUrl:@"null";
 */
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSDictionary * params = @{
                              kHttpParams_collectionSave_picUrl : self.picUrl.length > 0 ? self.picUrl:@"null",
                              kHttpParams_collectionSave_status : self.status.length > 0 ? self.status:@"1",
                              kHttpParams_collectionSave_duration : self.duration.length > 0 ? self.duration:@"0",
                              kHttpParams_collectionSave_userName:[[WVRUserModel sharedInstance] username],
                              kHttpParams_collectionSave_videoType:self.videoType.length > 0 ? self.videoType:@"moretv_2d",
                              kHttpParams_collectionSave_programCode:self.code,
                              kHttpParams_collectionSave_programName:self.programName.length > 0 ? self.programName:@"programName",
                              kHttpParams_collectionSave_programType:self.programType.length > 0 ? self.programType:@"recorded",
                              kHttpParams_collectionSave_userLoginId:[WVRUserModel sharedInstance].accountId,
                              };
    return params;
}
@end
