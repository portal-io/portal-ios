//
//  WVRRNUserModule.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNUserModule.h"
#import <React/RCTBridgeModule.h>
#import "WVRMediator+AccountActions.h"
#import "WVRRNUserModel.h"

@interface WVRRNUserModule()<RCTBridgeModule>

@end

@implementation WVRRNUserModule

//-(void)getUserInfo:(RCTResponseSenderBlock)callbcak
//{
//
//}

RCT_EXPORT_MODULE(WVRRNUserModule); //注意这里不要加引号和 @ ，直接写模块的名字就可以了。

//RCT_EXPORT_METHOD(add:(NSInteger)numA andNumB:(NSInteger)numB result:(RCTResponseSenderBlock)callback) {
//    callback(@[@(numA + numB)]);
//}
RCT_EXPORT_METHOD(getUserInfo:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
//    RACCommand *successCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
////            @strongify(self);
//            WVRUserModel * userModel = [WVRUserModel sharedInstance];
//            NSDictionary *json = [userModel yy_modelToJSONObject];
//            resolve(json);
//            return nil;
//        }];
//    }];
//
//    RACCommand *cancelCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            //            @strongify(self);
//            reject(nil,nil,nil);
//            return nil;
//        }];
//    }];
    
//    NSDictionary *dict = @{ @"completeCmd":successCmd, @"cancelCmd":cancelCmd };
    
    if ([WVRUserModel sharedInstance].isisLogined) {
        WVRUserModel * userModel = [WVRUserModel sharedInstance];
        NSDictionary *json = [userModel yy_modelToJSONObject];
        resolve(json);
        return;
    }else{
        reject(@"-1", @"未登录", nil);
    }
}


@end
