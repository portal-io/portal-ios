//
//  WVRPlayerViewHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRPlayerViewHeader_h
#define WVRPlayerViewHeader_h

typedef NS_ENUM(NSInteger,WVRPlayerToolVStatus) {
    WVRPlayerToolVStatusDefault = 0,
    WVRPlayerToolVStatusLock = 1,
    WVRPlayerToolVStatusNotLock = 2,
    WVRPlayerToolVStatusPreparing = 3,
    WVRPlayerToolVStatusPrepared = 4,
    WVRPlayerToolVStatusPlaying = 5,
    WVRPlayerToolVStatusPause = 6,
    WVRPlayerToolVStatusUserPause = 7,
    WVRPlayerToolVStatusStop = 8,
    WVRPlayerToolVStatusComplete = 9,
    WVRPlayerToolVStatusError = 10,
    WVRPlayerToolVStatusChangeQuality = 11,
    WVRPlayerToolVStatusSliding = 12,
//    WVRPlayerToolVStatusLoading,
    WVRPlayerToolVStatusVR = 13,
    WVRPlayerToolVStatusNotVR = 14,
    WVRPlayerToolVStatusAnimating = 15,
    WVRPlayerToolVStatusAnimationComplete = 16,
    
    WVRPlayerToolVStatusFree = 17,
    WVRPlayerToolVStatusNeedPay = 18,
    WVRPlayerToolVStatusWatingPay = 19,
    WVRPlayerToolVStatusPaySuccess = 20,
    WVRPlayerToolVStatusPayFail = 21,
    
    WVRPlayerToolVStatusPreChooseDrama = 22,
    WVRPlayerToolVStatusWatingChooseDrama = 23,
    WVRPlayerToolVStatusChoosedDrama = 24,
    WVRPlayerToolVStatusDramaPlayEnd = 25,          // 互动剧播放结束
    
    WVRPlayerToolVStatusGiftHiden = 26,
    WVRPlayerToolVStatusGiftShow = 27,
};
//#define LEFT_LEADING_PLAYER_VIEW (kDevice_Is_iPhoneX&&(SCREEN_WIDTH>SCREEN_HEIGHT)? kStatuBarHeight:0)
#define LEFT_LEADING_TOP_VIEW (0)
#define LEFT_LEADING_VIEW (kDevice_Is_iPhoneX? kStatuBarHeight:0)
#define RIGHT_TRAINING_VIEW (kDevice_Is_iPhoneX? (kTabBarHeight-49.f):0)

#define HEIGHT_TOP_VIEW_DEFAULT (60.f)
#define HEIGHT_TOP_VIEW_ADJUST (MIN(SCREEN_HEIGHT, SCREEN_WIDTH) * 0.11f)
#define HEIGHT_TOP_VIEW_LIVE (kDevice_Is_iPhoneX? 78.f+kStatuBarHeight:78.f)
#define HEIGHT_TOP_VIEW_LIVE_H (60.f)
#define HEIGHT_TOP_VRMODE_VIEW_DEFAULT (90.f)
#define HEIGHT_BOTTOM_VIEW_LIVE (60.f)//kDevice_Is_iPhoneX? (kTabBarHeight-49.f)+60.f:
#define HEIGHT_BOTTOM_VIEW_LIVE_H (kDevice_Is_iPhoneX? (kTabBarHeight-49.f)+60.f:60.f)
#define HEIGHT_BOTTOM_VIEW_ADJUST (MIN(SCREEN_HEIGHT, SCREEN_WIDTH) * 0.11f)
#define WIDTH_LEFT_VIEW_DEFAULT (kDevice_Is_iPhoneX? 60.f+kStatuBarHeight:60.f)
#define WIDTH_RIGHT_VIEW_DEFAULT (kDevice_Is_iPhoneX? (kTabBarHeight-49.f)+60.f:60.f)

#endif /* WVRPlayerViewHeader_h */
