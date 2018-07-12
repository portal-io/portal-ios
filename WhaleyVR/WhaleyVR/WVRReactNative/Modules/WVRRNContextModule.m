//
//  WVRRNContextModule.m
//  WhaleyVR
//
//  Created by qbshen on 2018/1/16.
//  Copyright © 2018年 Snailvr. All rights reserved.
//

#import "WVRRNContextModule.h"
#import <React/RCTBridgeModule.h>

@interface WVRRNContextModule()<RCTBridgeModule>

@end

@implementation WVRRNContextModule

RCT_EXPORT_MODULE(WVRRNContextModule); //注意这里不要加引号和 @ ，直接写模块的名字就可以了。
RCT_EXPORT_METHOD(isTest:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
//    @try{
//        BOOL isTest = [WVRUserModel sharedInstance].isTest;
//        resolve(@{@"isTest":[NSNumber numberWithBool:isTest]});
//    }
//    @catch (NSException* e){
//        reject(@"-1",@"error",e);
//    }
    
}


@end
