//
//  WVRRNIntentModule.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNInitModule.h"
#import <React/RCTBridgeModule.h>

@interface WVRRNInitModule()<RCTBridgeModule>

@end

@implementation WVRRNInitModule

RCT_EXPORT_MODULE(WVRRNInitModule); //注意这里不要加引号和 @ ，直接写模块的名字就可以了。
RCT_EXPORT_METHOD(setJsInited){
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * curVC = [UIViewController getCurrentVC];
        [curVC hideProgress];
    });
}
                  
+(BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
