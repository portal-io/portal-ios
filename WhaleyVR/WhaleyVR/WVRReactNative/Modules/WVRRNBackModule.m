//
//  WVRRNBackModule.m
//  WhaleyVR
//
//  Created by 杨芷 on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNBackModule.h"
#import <React/RCTBridgeModule.h>
#import "WVRBaseViewController.h"
#import "WVRRNGoldViewController.h"

@interface WVRRNBackModule() <RCTBridgeModule>

@end

@implementation WVRRNBackModule

- (NSDictionary *)constantsToExport
{
    return @{ @"RESULT_CANCEL": @(0),
              @"RESULT_OK": @(-1),
              @"RESULT_FIRST_USER": @(1),
              };
}

RCT_EXPORT_MODULE(WVRRNBackModule);

RCT_EXPORT_METHOD(goBack:(NSDictionary*)result
                 resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
//        if(!result){
//            reject(@"",@"",nil);
//            return;
//        }
        UIViewController* currentVC = [UIViewController getCurrentVC];
        if(!currentVC){
            reject(@"",@"",nil);
            return;
        }
        if(![currentVC isKindOfClass:[WVRBaseViewController class]]){
            reject(@"",@"",nil);
            return;
        }
        WVRBaseViewController* rnVC = (WVRBaseViewController*)currentVC;
        id resultCode = result[@"resultCode"];
        id resultData = result[@"data"];
//        if(!resultCode
//           ||
//           ![resultCode isKindOfClass:[NSNumber class]]
//        ){
//            reject(@"",@"",nil);
//            return;
//        }
//        if(resultData
//           &&
//           ![resultData isKindOfClass:[NSDictionary class]]
//        ){
//            if (reject) {
//                reject(@"",@"",nil);
//            }
//            return;
//        }
        [rnVC backForResult:resultData resultCode:0];
        if (resolve) {
            resolve(@(YES));
        }
    });
}

+(BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
