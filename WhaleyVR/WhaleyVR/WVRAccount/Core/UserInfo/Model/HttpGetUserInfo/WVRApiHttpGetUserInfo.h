//
//  WVRHttpUserInfo.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRNet/WVRAPIBaseManager.h>

UIKIT_EXTERN NSString * const kHttpParams_userInfo_device_id ;
UIKIT_EXTERN NSString * const kHttpParams_userInfo_accesstoken ;

@interface WVRApiHttpGetUserInfo : WVRAPIBaseManager<WVRAPIManager>

@end
