//
//  WVRUnityPlayerViewModel.h
//  Unity-iPhone
//
//  Created by dy on 2017/12/13.
//

#import <Foundation/Foundation.h>
#import "WVRItemModel.h"

typedef NS_ENUM(NSInteger, UnityPlayerPlayStatus) {
    
    UnityPlayerPlayStatusPreparing,     // 准备播放，prepare之前
    UnityPlayerPlayStatusPlaying,       // 播放中
    UnityPlayerPlayStatusPause,         // 暂停
    UnityPlayerPlayStatusBuffering,     // 卡顿
    UnityPlayerPlayStatusComplation,    // 播放完成
    UnityPlayerPlayStatusError,         // 播放失败
};

typedef NS_ENUM(NSInteger, UnityPlayerToastType) {
    
    UnityPlayerToastTypeLoading,    // 加载网速
    UnityPlayerToastTypeMsg,        // 消息
};

@protocol WVRUnityPlayerViewModelDelegate<NSObject>

- (void)showToast;
- (void)hideToast;
- (void)scheduleHideControls;

@end

#define UnityDefaultToastTime 0.25f

@interface WVRUnityPlayerViewModel : NSObject

@property (nonatomic, weak) id<WVRUnityPlayerViewModelDelegate> delegate;

// MARK: - 传值变量

@property (nonatomic, assign) WVRStreamType streamType;
@property (nonatomic, assign) WVRDetailType detailType;

@property (nonatomic, assign) long duration;
@property (nonatomic, assign) long position;
@property (nonatomic, assign) long buffer;

@property (nonatomic, assign) long playCount;
@property (nonatomic, assign) BOOL isFromBanner;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *definition;

//@property (nonatomic, copy  ) NSString *toastStr;
@property (nonatomic, copy  ) NSAttributedString *toastStr;
//@property (nonatomic, strong) UIColor  *toastColor;

/// 为YES时表示到固定时间就会消失
@property (nonatomic, assign) BOOL      toastIsTemp;

/// 当前所要控制的toast的id编号
@property (nonatomic, copy  ) NSString *currentToastId;
@property (nonatomic, assign) UnityPlayerToastType toastType;

@property (atomic, assign) BOOL showingToast;

// MARK: - 状态变量

@property (nonatomic, assign) UnityPlayerPlayStatus playStatus;

@property (nonatomic, assign) BOOL unitySceneReady;

// MARK: - functions

- (void)definitionBtnClick:(UIButton *)sender;

- (void)backBtnClick:(UIButton *)sender;

//- (void)closeBtnClick:(UIButton *)sender;

- (void)vrModeBtnClick:(UIButton *)sender;

- (void)playBtnClick:(UIButton *)sender;

/// 直播关闭按钮点击事件
- (void)liveCloseBtnClick:(UIButton *)sender;

- (void)changeProgress:(long)position;

/// 点击热区 0 down，1 up，2 cancel
- (void)hotSpotClick:(NSString *)event;

/// Unity调用showToast
- (void)showToast;

/// Unity调用hideToast
- (void)hideToast;

@end
