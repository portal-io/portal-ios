//
//  WVRProgramDefine.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRProgramDefine_h
#define WVRProgramDefine_h

#import <UIKit/UIKit.h>

#define login_btn_tag 100

#define security_btn_tag 200
#define VerifyCode_btn_tag 300


#define ACCOUNT_PWLOGIN_tag 0
#define FORGOTPW_tag 1
#define SMS_SHORT_LOGIN_tag 2
#define WB_btn_tag 600


#define QQ_btn_tag 400
#define WX_btn_tag 500
#define WB_btn_tag 600

UIKIT_EXTERN NSString *const kAppBannerId;

// "type": "1",//推荐位类型（1：正常；2：轮播；3：广告；4：品牌广告；5：热门频道；6：标题；7：秀场；8：电视猫；9：发布者；10：电影；11：单个banner播放；12：互动剧；13：广告位（启动）；14：活动海报；15：内容推荐浮层。）

typedef NS_ENUM(NSInteger, WVRRecommndAreaType) {
    
    WVRRecommndAreaTypeNormal = 1,
    WVRRecommndAreaTypeBanner = 2,
    WVRRecommndAreaTypeAD = 3,
    WVRRecommndAreaTypeBrand = 4,
    WVRRecommndAreaTypeHot = 5,
    WVRRecommndAreaTypeTitle = 6,
    WVRRecommndAreaTypeShow = 7,
    WVRRecommndAreaTypeTVMore = 8,
    WVRRecommndAreaTypePublisher = 9,
    WVRRecommndAreaTypeMovie = 10,
    WVRRecommndAreaTypeBannerPlay = 11,
    WVRRecommndAreaTypeDrama = 12,
    WVRRecommndAreaTypeLaunchAD = 13,
    WVRRecommndAreaTypePoster = 14,
    WVRRecommndAreaTypeSupernatant = 15,
};


typedef NS_ENUM(NSInteger, WVRPlayerToolVQuality) {
    
    WVRPlayerToolVQualityDefault,
    WVRPlayerToolVQualityST,
    WVRPlayerToolVQualitySD,
    WVRPlayerToolVQualityHD,
};


typedef NS_ENUM(NSInteger, WVRVideoDetailType) {
    
    WVRVideoDetailTypeVR = 1,                       // 全景
    WVRVideoDetailTypeLive,                         // 直播
    WVRVideoDetailTypeMovie,                        // 2D电影、短片
    WVRVideoDetailType3DMovie,                      // 3D/华数电影
    WVRVideoDetailTypeMoreTV,                       // 电视猫电视剧
    WVRVideoDetailTypeMoreMovie,                    // 电视猫电影
};

#import "WVRParserUrlResult.h"

#define DEFAULT_IMAGE_STR (@"default_image")
//#define HOLDER_IMAGE ([UIImage imageNamed:DEFAULT_IMAGE_STR])

#define DEFAULT_HEAD_IMAGE_STR (@"avatar_login")
#define HOLDER_HEAD_IMAGE ([UIImage imageNamed:DEFAULT_HEAD_IMAGE_STR])

#endif /* WVRProgramDefine_h */
