//
//  WVRPlayerUIProtocol.h
//  WVRPlayerUI
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerUIEvent.h"
#import "WVRPlayerUIEventCallBack.h"
#import "WVRPlayerViewHeader.h"

@protocol WVRPlayerUIProtocol <NSObject>

@required

#pragma mark - life cycle

/**
 添加一个播放器组件

 @param params 组件初始化需要的参数
 @return 是否初始化成功
 */
- (BOOL)addControllerWithParams:(NSDictionary *_Nullable)params;

/**
 暂停模块中的事件循环
 */
- (void)pauseController;

/**
 继续模块中的事件循环,与pause配对
 */
- (void)resumeController;

/**
 移除控件模块
 */
- (void)removeController;

/**
 优先级 越大优先级越高

 @return 越大优先级越高
 */
- (unsigned long)priority;

/**
 播放器主控制器事件传递给组件

 @param event 事件及参数
 @return 组件处理事件的返回值 不处理则返回nil
 */
- (WVRPlayerUIEventCallBack *_Nullable)dealWithEvent:(WVRPlayerUIEvent *_Nonnull )event;

@end


@protocol WVRPlayerUIManagerProtocol <NSObject>

@required

/// UIManager初始化的时候调用
- (void)installAfterSetParams;

/// 详情数据返回后更新组件，子类可重写该方法
- (void)updateAfterSetParams;

- (void)showStatusBar;

- (BOOL)actionSwitchVR;

- (void)resetActionSwitchVR;

// MARK: - Screen Rotation

- (void)forceToOrientationPortrait;

- (void)forceToOrientationPortrait:(void(^_Nullable)(void))completionBlock;

- (void)forceToOrientationPortraitWithAnimation:(void(^_Nullable)(void))animationBlock completion:(void(^_Nullable)(void))completionBlock;

- (void)forceToOrientationMaskLandscapeRight;

- (void)forceToOrientationMaskLandscapeRight:(void(^_Nullable)(void))completionBlock;

- (void)forceToOrientationMaskLandscapeRightWithAnimation:(void(^_Nullable)(void))animationBlock completion:(void(^_Nullable)(void))completionBlock;

//刷新控件步骤：1，更新对应的playViewCellViewModel。 2. 调用playView reloadData 方法 或者需要转屏的直接转屏（转屏方法中已经调用reloadData）
- (void)changeViewFrameForFull;

- (void)changeViewFrameForSmall;

- (void)updateAnimationStatus:(WVRPlayerToolVStatus)status;

- (void)updateVRStatus:(WVRPlayerToolVStatus)status;

- (void)updatePlayStatus:(WVRPlayerToolVStatus)status;;
// 子类实现
//- (void)changeViewFrameForVRFull;

/**
 调用Manager处理或转发事件

 @param event 事件及其参数
 @return 组件处理事件的返回值 不处理则返回nil
 */
- (WVRPlayerUIEventCallBack *_Nullable)dealWithEvent:(WVRPlayerUIEvent *_Nonnull )event;

@end
