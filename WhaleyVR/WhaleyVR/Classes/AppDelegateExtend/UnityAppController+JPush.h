//
//  UnityAppController+JPush.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "UnityAppController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger, WVRJPushMsgType) {
    //1=主页；2=专题列表；3=H5；4=直播；5=详情页；
    WVRJPushMsgTypeHome = 1,
    WVRJPushMsgTypeTopic = 2,
    WVRJPushMsgTypeH5 = 3,
    WVRJPushMsgTypeLive = 4,
    WVRJPushMsgTypeDetail = 5
    
};

typedef NS_ENUM(NSInteger, WVRJPushMsgDetailType) {
    //1=全景视频；4=2d电影；5=3d电影；6=互动剧；
    WVRJPushMsgDetailTypeVR = 1,
    WVRJPushMsgDetailTypeMoreTV = 2,
    WVRJPushMsgDetailTypeMoreTVMOVIE = 3,
    WVRJPushMsgDetailType2D = 4,
    WVRJPushMsgDetailType3D = 5,
    WVRJPushMsgDetailTypeDrama = 6
};

@interface WVRJPushMsgModel : NSObject

@property (nonatomic, assign) WVRJPushMsgType msg_type;
@property (nonatomic, strong) NSString * msg_param;
@property (nonatomic, strong) NSString * title;//h5页面标题使用

@property (nonatomic, assign) WVRJPushMsgDetailType msg_detail_type;

@end

@interface UnityAppController (JPush)

- (void)setTagsAlias;
- (void)initJPushSDKWithOptions:(NSDictionary *)launchOptions;

@end
