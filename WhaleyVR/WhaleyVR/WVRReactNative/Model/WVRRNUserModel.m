//
//  WVRRNUserModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNUserModel.h"
#import <React/RCTBridgeModule.h>

@interface WVRRNUserModel() <RCTBridgeModule>

@end

@implementation WVRRNUserModel

RCT_EXPORT_MODULE(WVRRNUserModel); //注意这里不要加引号和 @ ，直接写模块的名字就可以了。

//RCT_EXPORT_METHOD(username) {
//    NSLog(@"%@", text);
//}

//-(NSString *)username
//{
//    NSString * cur = [WVRUserModel sharedInstance].username;
//    return cur;
//}
@end
