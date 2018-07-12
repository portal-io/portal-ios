//
//  WVRNetDataReformerAccount+updateUser.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetDataReformerAccount+updateUser.h"
#import "WVRHttpUserModel.h"

@implementation WVRNetDataReformerAccount (updateUser)

- (void)updateUserDefaultInfo:(WVRHttpUserModel *)resSuccess {
    
    if (resSuccess.username)
        [WVRUserModel sharedInstance].username = resSuccess.username;
    if (resSuccess.heliosid || resSuccess.account_id)
        [WVRUserModel sharedInstance].accountId = resSuccess.heliosid.length > 0 ? resSuccess.heliosid : resSuccess.account_id;
    if (resSuccess.accesstoken)
        [WVRUserModel sharedInstance].sessionId = resSuccess.accesstoken;
    if (resSuccess.accesstoken)
        [WVRUserModel sharedInstance].expiration_time = resSuccess.expiretime;
    if (resSuccess.refreshtoken)
        [WVRUserModel sharedInstance].refreshtoken = resSuccess.refreshtoken;
    if (resSuccess.mobile)
        [WVRUserModel sharedInstance].mobileNumber = resSuccess.mobile;
    if (resSuccess.avatar)
        [WVRUserModel sharedInstance].loginAvatar = resSuccess.avatar;
}

@end
