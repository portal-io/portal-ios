//
//  WVRAppEnterReportUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAppEnterReportUseCase.h"
#import "WVRHttpAppEnter.h"
#import "WVRAppEnterReformer.h"
#import "WVRErrorViewModel.h"
#import <AdSupport/AdSupport.h>
#import "WVRGlobalUtil.h"
#import "NSString +AES256.h"


@implementation WVRAppEnterReportUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRHttpAppEnter alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        id result = [self.requestApi fetchDataWithReformer:[[WVRAppEnterReformer alloc] init]];
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
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    // idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //    idfa = @"9AE77E50-E8A1-47EE-B0DE-A1090796B99E";
    // ip
    //    NSString *ip = [WVRGlobalUtil deviceIPAdress];
    NSString *ip = [WVRAppModel sharedInstance].ipAdress;
    //time
    NSString *timeString = [WVRGlobalUtil getTimeStr];
    //    timeString = @"1479814055076";
    // random
    NSString *random = [[WVRUserModel sharedInstance] random32];
    //    random = @"98498535702515573026212686126291";
    // platform
    NSString *platformType = @"ios";
    // version
    NSString *version = [WVRGlobalUtil getAppVersion];
    NSString *strForMd5 = [idfa stringByAppendingString:ip];
    strForMd5 = [strForMd5 stringByAppendingString:timeString];
    strForMd5 = [strForMd5 stringByAppendingString:random];
    strForMd5 = [strForMd5 stringByAppendingString:platformType];
    strForMd5 = [strForMd5 stringByAppendingString:version];
    NSLog(@"md5 msg: %@",strForMd5);
    NSString *md5Result = [WVRGlobalUtil md5HexDigest:strForMd5];
    NSLog(@"md5 msg r: %@",md5Result);
    
    NSString *strForAes = [[NSString alloc]init];
    strForAes = [strForAes stringByAppendingString:idfa];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:ip];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:timeString];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:random];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:platformType];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:version];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:md5Result];
    NSLog(@"aes msg: %@",strForAes);
    NSString *aesResult = [strForAes aes256_encrypt:cKey];
    httpDic[kHttpParams_enter_content] = aesResult;
    return httpDic;
}
@end
