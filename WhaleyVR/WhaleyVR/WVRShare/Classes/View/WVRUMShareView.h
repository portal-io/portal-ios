//
//  MyUMShareView.h
//  VRManager
//
//  Created by Snailvr on 16/7/5.
//  Copyright © 2016年 Snailvr. All rights reserved.

// WVRShare 已解耦，目前只依赖于UMSocial的Pod

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WVRShareType) {
    
    WVRShareTypeVideoDetails = 1,           // 视频详情分享
    WVRShareTypeWhaley,                     // 官方分享
    WVRShareTypeSpecialTopic,               // 专题分享
    WVRShareTypeSpecialProgramPackage,      // 节目包
    WVRShareTypeSpecialTopicDetails,        // 专题详情分享
    WVRShareTypeLive,                       // 直播
    WVRShareType3DMovie,                    // 3D电影
    WVRShareTypeH5,                         // web
    WVRShareTypeNews,                       // H5资讯
    WVRShareTypeMoreTV,                     // 电视猫电视剧
    WVRShareTypeMoreMovie,                  // 电视猫电影
    WVRShareTypeAboutUs,                    // 关于我们的分享
    WVRShareTypeDrama,                      // 互动剧
    WVRShareType2018SpringTopic,               // 2018春节活动
};

// 0 新浪微博 1 QQ好友 2 微信好友 3 QQ空间 4 微信朋友圈 5 复制链接
/// 分享类型，对应分享面板的按钮
typedef NS_ENUM(NSInteger, kSharePlatform) {
    
    kSharePlatformSina = 0,
    kSharePlatformQQ = 1,
    kSharePlatformWechat = 2,
    kSharePlatformQzone = 3,
    kSharePlatformFriends = 4,
    kSharePlatformLink = 5,
};

/*
 String SHARE_TEST_URL = "http://minisite.test.snailvr.com/app-share-h5/";
 String SHARE_URL = "http://minisite-c.snailvr.com/whaleyTopic/newvoicev2/";
 String SHARE_APP_URL = "http://a.app.qq.com/o/simple.jsp?pkgname=com.snailvr.manager&ckey=CK1340670182054";
 String SHARE_TOPIC_URL = SHARE_URL + "?code=%1$s";
 String SHARE_LIVE_DETAIL = SHARE_URL + "liveProgram.html?code=%1$s";
 String SHARE_DETAIL = SHARE_URL + "viewthread.html?code=%1$s";
 String SHARE_3D_DETAIL = SHARE_URL + "viewthread3D.html?code=%1$s";
 */
/**********************   友盟分享    ********************/
#define kShare_BaseURL          @"http://minisite-c.snailvr.com/whaleyTopic/newvoicev2/"
#define kShareWhaleyUrl         @"http://a.app.qq.com/o/simple.jsp?pkgname=com.snailvr.manager&ckey=CK1340670182054"

#define kShareUrl               @"https://itunes.apple.com/us/app/vr-guan-jia/id963637613?l=zh&ls=1&mt=8"
#define kOpenAppStoreUrl        @"itms-apps://itunes.apple.com/us/app/vr-guan-jia/id963637613?l=zh&ls=1&mt=8"
#define kSinaRedirectUrl        @"http://sns.whalecloud.com/sina2/callback"


typedef void (^shareCancleBlock)(void);
typedef void (^shareCompletionBlock)(kSharePlatform platform, BOOL success);


@interface WVRUMShareView : UIView

@property (nonatomic, assign) WVRShareType shareType;

// 用来确定是弹出界面点击后分享还是H5直接吊起的分享
@property (nonatomic, assign) BOOL isH5CallShare;

- (instancetype)init NS_UNAVAILABLE;

//- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 关于我们 页面专用
+ (WVRUMShareView *)shareForAbout;

/// 页面分享
+ (WVRUMShareView *)shareWithContainerView:(UIView *)containerView
                                   sID:(NSString *)sid
                               iconUrl:(NSString *)url
                                 title:(NSString *)title
                                 intro:(NSString *)intro
                                 mobId:(NSString *)mobId
                             shareType:(WVRShareType)type;

/// Web分享
+ (WVRUMShareView *)shareWithContainerView:(UIView *)containerView
                                   sID:(NSString *)sid
                               iconUrl:(NSString *)url
                                 title:(NSString *)title
                                 intro:(NSString *)intro
                              shareURL:(NSString *)shareURL
                             shareType:(WVRShareType)type;


// 0 新浪微博 1 QQ好友 2 微信好友 3 QQ空间 4 微信朋友圈 5 复制链接
- (void)shareToIndex:(kSharePlatform)index;

/// 分享按钮点击后的回调
@property (nonatomic, copy) void(^clickBlock)(kSharePlatform platform);

/// 分享取消的回调
@property (nonatomic, copy) shareCancleBlock cancleBlock;

/// 分享成功的回调
@property (nonatomic, copy) shareCompletionBlock completionBlock;

@end
