//
//  WVRWebSocketPrepare.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRWebSocketPrepare.h"
#import "WVRHttpRoomLogin.h"
//#import "WVRLoginTool.h"
#import "WVRWebSocketConfig.h"
#import "WVRHttpUserAuth.h"
#import "WVRHttpGuestUserAuth.h"
#import "WVRAuthModel.h"
#import "WVRRoomModel.h"
#import "WVRAppContextHeader.h"

@interface WVRWebSocketPrepare ()

@property (nonatomic, strong) WVRAuthModel * gAuthModel;

@property (nonatomic, strong) WVRRoomModel * gRoomModel;

@end


@implementation WVRWebSocketPrepare

- (void)defaultAuth:(WVRWebSocketConfig *)config
{
    if ([WVRUserModel sharedInstance].isisLogined) {
        [self authWebSocket:config];
    } else {
        [self guest_authWebSocket:config];
    }
}

- (void)authWebSocket:(WVRWebSocketConfig*)config
{
    kWeakSelf(self);
    WVRHttpUserAuth *api = [[WVRHttpUserAuth alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kWVRHttpUserAuth_model] = [[UIDevice currentDevice] systemVersion];
    params[kWVRHttpUserAuth_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    params[kWVRHttpUserAuth_device_id] = [WVRUserModel sharedInstance].deviceId;
    
    api.bodyParams = params;
    api.successedBlock = ^(WVRAuthModel *authModel) {
        config.authModel = authModel;
        weakself.gAuthModel = authModel;
        if ([weakself.delegate respondsToSelector:@selector(authStatus:)]) {
            [weakself.delegate authStatus:YES];
        }
        
        [weakself http_cominRoom:config authModel:authModel];
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
        if ([weakself.delegate respondsToSelector:@selector(authStatus:)]) {
            [weakself.delegate authStatus:NO];
        }
    };
    [api loadData];
    
}

- (void)guest_authWebSocket:(WVRWebSocketConfig *)config {
    
    kWeakSelf(self);
    WVRHttpGuestUserAuth *api = [[WVRHttpGuestUserAuth alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kWVRHttpGuestUserAuth_model] = [[UIDevice currentDevice] systemVersion];;
    params[kWVRHttpGuestUserAuth_device_id] = [WVRUserModel sharedInstance].deviceId;
    
    api.bodyParams = params;
    api.successedBlock = ^(WVRAuthModel *authModel) {
        config.authModel = authModel;
        weakself.gAuthModel = authModel;
        if ([weakself.delegate respondsToSelector:@selector(guestAuthStatus:)]) {
            [weakself.delegate guestAuthStatus:YES];
        }
        [weakself http_cominRoom:config authModel:authModel];
        
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
        if ([weakself.delegate respondsToSelector:@selector(guestAuthStatus:)]) {
            [weakself.delegate guestAuthStatus:NO];
        }
    };
    [api loadData];
}

- (void)http_cominRoom:(WVRWebSocketConfig*)config authModel:(WVRAuthModel *)authModel {
    
    kWeakSelf(self);
    if (![authModel.statusCode isEqualToString:@"1"]) {
        DDLogInfo(@"秀场认证用户失败");
        return ;
    }
    WVRHttpRoomLogin *curapi = [[WVRHttpRoomLogin alloc] init];
    NSMutableDictionary *curparams = [NSMutableDictionary dictionary];
    curparams[kWVRHttpRoomLogin_sid] = config.programId;//@"cce59d0bb6a5463f817dc3023be5ec9f";
//    const char *char_content = [config.programName cStringUsingEncoding:NSUTF8StringEncoding];
//    NSString * strUtf8 = [NSString stringWithUTF8String:char_content];
//    NSLog(@"strUtf8:%@",strUtf8);
    NSString* nameByTrim = [config.programName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    nameByTrim = [nameByTrim stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSLog(@"ByTrim:%@", nameByTrim);
    NSCharacterSet * cSet = [[NSCharacterSet characterSetWithCharactersInString:@" @#$%^&+=\\|[]{}:;\"?/<>,"] invertedSet];
    NSString * encodingString = [nameByTrim stringByAddingPercentEncodingWithAllowedCharacters:cSet];
    curparams[kWVRHttpRoomLogin_title] = encodingString;
    curapi.bodyParams = curparams;
    curapi.successedBlock = ^(WVRRoomModel *model) {
        if ([model.status integerValue] != 1) {
            if ([weakself.delegate respondsToSelector:@selector(cominStatus:)]) {
                [weakself.delegate cominStatus:NO];
            }
            return ;
        }
        config.roomModel = model;
        if ([weakself.delegate respondsToSelector:@selector(cominStatus:)]) {
            [weakself.delegate cominStatus:YES];
        }
        weakself.gRoomModel = model;
//        [weakself setUpSocketIO:config.programId];
    };
    curapi.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
        if ([weakself.delegate respondsToSelector:@selector(cominStatus:)]) {
            [weakself.delegate cominStatus:NO];
        }
    };
    
    [curapi loadData];
}

@end
