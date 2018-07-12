//
//  WVRPlayerHelper.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/19.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WhaleyVRPlayer/WVRDataParam.h>
#import <WhaleyVRPlayer/WVRPlayer.h>
#import <GLKit/GLKit.h>
#import "WVRVideoParamEntity.h"
#import "WVRPlayerBIModel.h"

typedef NS_ENUM(NSInteger, WVRPlayerErrorCode) {
    
    WVRPlayerErrorCodeNet = -1000,      // 网络问题
    WVRPlayerErrorCodeLink = -2000,     // 链接或解析错误
    WVRPlayerErrorCodePlay = -3000,     // 播放错误
};

//播放事件代理
@protocol WVRPlayerHelperDelegate <NSObject>

@required

/// 播放器加载完成，即将播放
- (void)onVideoPrepared;

/// 视频播放完毕
- (void)onCompletion;

/// 视频播放出错
- (void)onError:(int)code;

/// 视频开始 加载/卡顿
- (void)onBuffering;

/// 视频 加载/卡顿 结束
- (void)onBufferingOff;

/// 网络环境切换后代理库的链接失效，需要重新解析链接
- (void)reParserUrlForNetChanged:(long)position;

/// onBack后就不再执行此代理
- (void)onGLKVCdealloc;

@optional

/// 播放器暂停后（包括认为暂停和操作系统将应用挂起等造成的暂停），回调到UI
- (void)pauseUI;

/// 特殊情况下造成的重新播放，需要重置UI状态
- (void)restartUI;

- (BOOL)respondNetStatusChange;

/// 重试链接的时候赋值，不需要必须实现
- (void)setCurPosition:(long)curPosition;

/// 用户执行seek操作，position要seek到的时间节点
- (void)userSeekTo:(long)position;

@end


@interface WVRPlayerHelper : NSObject

/// 内部创建，对外可操作其属性
@property (nonatomic, strong, readonly) WVRPlayer *vrPlayer;
/// 内部创建，对外可操作其属性
@property (nonatomic, strong, readonly) WVRDataParam *dataParam;

/// glkView 的父视图
@property (nonatomic, weak, readonly) UIView *containerView;
/// glkViewController 的父视图控制器
@property (nonatomic, weak, readonly) UIViewController *containerController;

/// 持有一个VideoEntity对象，用于状态判断，数据埋点等
@property (nonatomic, weak) WVRVideoParamEntity *ve;

/// 播放事件回调代理
@property (weak, nonatomic) id<WVRPlayerHelperDelegate> playerDelegate;

/// 是否忽略网络状态
//@property (nonatomic, assign) BOOL gIngnoreNetStatus;

#pragma mark - 存储属性

/// current playing sid, onError will be nil
@property (nonatomic, copy    ) NSString *curPlaySid;

/// last play sid,just for BI,sometimes be nil
@property (nonatomic, copy, readonly) NSString *lastSid;

/// buffer, seek，onPrepare之前
@property (nonatomic, readonly) BOOL isOnBuffering;

//播放器释放完成后回调标记
@property (atomic, readonly) BOOL isGLKDealloc;

/// 是否释放了资源
@property (atomic, readonly) BOOL isReleased;
/// 是否已经执行过销毁方法
@property (atomic, readonly) BOOL isOnDestroy;
/// onBack调用过则为YES，表示此player永久销毁
@property (atomic, readonly) BOOL isOnBack;
/// 当前是否可用，播放器对象存在
@property (nonatomic, readonly) BOOL isValid;
/// 该视频是否已经播放成功
@property (nonatomic, readonly) BOOL isOnPrepared;
/// 试看是否已经结束（业务逻辑辅助）
@property (nonatomic, assign) BOOL isFreeTimeOver;

/// 播放器BI相关数据Model
@property (nonatomic, strong) WVRPlayerBIModel *biModel;

/// 进后台之前是否为暂停状态
@property (nonatomic, assign, readonly) BOOL isPauseStatus;

/// Error Code For BI
@property (nonatomic, assign) int errorCode;

#pragma mark - 业务逻辑相关

/// 播放出错状态记录
- (void)playError:(NSString *)err code:(int)code videoEntity:(WVRVideoParamEntity *)ve;

/// BI 记录低帧率播放状态
//- (void)trackEventForLowbitrate;

#pragma mark 生命周期函数

- (instancetype)init NS_UNAVAILABLE;

/// viewDidLoad调用
- (instancetype)initWithContainerView:(UIView *)containerView MainController:(UIViewController *)viewController;

/// applicationWillResignActive调用, 返回YES表示pause时需更改UI为暂停状态
- (BOOL)onPause;
/// applicationDidBecomeActive调用, 返回YES表示resume时需更改UI为播放状态
- (BOOL)onResume;

/// 跳转出控制器的时候调用, 释放播放器资源, 不回调代理onGLKVCdealloc，允许setParamAndPlay
- (void)destroyPlayer;
/// 跳转Unity时调用，销毁完成后回调代理onGLKVCdealloc，允许setParamAndPlay
- (void)destroyForUnity;
/// 按退出键时调用, 不再回调代理onGLKVCdealloc，播放器彻底销毁，不允许setParamAndPlay
- (void)onBackForDestroy;

- (BOOL)checkNetStatus;

#pragma mark - 播放基础事件

/// 设置基础播放信息并开始播放视频
- (void)setParamAndPlay:(WVRDataParam *)dataParam;

/// 选择是否硬解码
- (void)switchDecoder:(BOOL)isHardDecode;
/// 恢复播放
- (void)start;
/// 暂停播放
- (void)stop;

/// SDK状态信息，是否在播放
- (BOOL)isPlaying;
/// SDK状态信息，只有视频播放状态处在setParamAndPlay和onVideoPrepared之前时返回TRUE
- (BOOL)isPrepared;

/**
 直接跳至某个时间点进行播放，直播不支持该操作

 @param time 时间，单位为毫秒 ms
 */
- (void)seekTo:(long)time;

#pragma mark 渲染状态事件

/// 设置播放底图
- (void)genBottomView:(float)scale Image:(UIImage *)image;      // onVideoPrepared之后执行

/// 设置底图隐藏状态
- (void)setBottomViewHidden:(BOOL)isHidden;

/// 足球180°格式，背景图
- (void)setBackImage:(UIImage *)image;

/// 设置渲染类型
- (void)setRenderType:(WVRRenderType)renderType;

/// 设置为单屏播放
- (void)setMonocular:(BOOL)isMonocular;

/// 重置视角
- (void)orientationReset;

#pragma mark - 全景视频用户拖拽改变视角

/// 用户手势拖拽开始
- (void)viewTouchesStarted;

/// 用户手势拖拽移动
- (void)viewTouchesMoved:(float)x Y:(float)y;

#pragma mark - getter

/// 获取当前播放进度（已重写get）
- (long)getCurrentPosition;
/// 获取可播放进度
- (long)getPlayableDuration;
/// SDK获取视频总时长
- (long)getDuration;

/// 当前播放器是否处于播放完成状态
- (BOOL)isComplete;

/// 当前播放器是否处于播放错误状态
- (BOOL)isPlayError;

/// 当前是否为暂停状态 （包括主动暂停和挂起）
- (BOOL)isPaused;

/// 获取播放帧率 BI
- (float)getFps;

/// 获取当前播放器渲染类型
- (WVRRenderType)getRenderType;

/// 当前播放器是否为单屏模式
- (BOOL)getMonocular;

- (void)resetIsPauseStatusForBanner;

/// 获取设备方向状态
- (UIDeviceOrientation)getDeviceOritation;

/// 重置解析库本地代理token
+ (void)resetLinkParserTokenForUrl:(NSString *)url;

@end


@interface WVRPlayerManager : NSObject

@property (atomic, strong, readonly) WVRPlayer *vrPlayer;

@property (atomic, weak, readonly) GLKView *glView;

@property (atomic, weak, readonly) GLKViewController *glController;

@property (atomic, readonly) BOOL isFullScreenPlaying;

+ (instancetype)sharedInstance;

- (void)setGlView:(GLKView *)glView;

- (void)setGlController:(GLKViewController *)glController;

- (UIImage *)screenShotForGLKView;

@end
