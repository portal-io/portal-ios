//
//  WVRUnityPlayerViewModel.m
//  Unity-iPhone
//
//  Created by dy on 2017/12/13.
//

#import "WVRUnityPlayerViewModel.h"
#import "WVRMediator+UnityActions.h"
#import "UnityTools.h"
#import "WVRUnityManager.h"

#define UnityExitDelayTime 0.1f

@interface WVRUnityPlayerViewModel ()

@property (assign, nonatomic) NSTimeInterval playClickTime;

@end

@implementation WVRUnityPlayerViewModel

static NSString *NEXT_DEFINITION = @"split_next_definition";
static NSString *START = @"split_start";
static NSString *PAUSE = @"split_pause";
static NSString *RESTART = @"split_restart";
static NSString *DESTROY = @"split_destroy";
static NSString *CHANGE_PROGRESS = @"split_change_progress";

- (void)definitionBtnClick:(UIButton *)sender {
    
    NSLog(@"unity_definitionBtnClick:");
    
    if (self.streamType == STREAM_VR_LOCAL) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(scheduleHideControls)]) {
        [self.delegate scheduleHideControls];
    }
    
    // 切换下个清晰度
    [UnityTools sendMessageToUnity:NEXT_DEFINITION argumentList:nil];
}

- (void)backBtnClick:(UIButton *)sender {
    
    NSLog(@"unity_backClick:");
    
    // 针对Unity只作为播放器的版本
    [WVRUnityManager sharedManager].playerHelper.dataParam.position = [[WVRUnityManager sharedManager].unityPlayer getCurrentPosition];
    
    self.playStatus = UnityPlayerPlayStatusPreparing;
    
    if (!self.isFromBanner &&
        [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack != WVRPlayerUnityBackDealExit) {
        [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack = WVRPlayerUnityBackDealRotation;
    }
    
    // 退出unity分屏模式
    [UnityTools sendMessageToUnity:DESTROY argument:@"true", nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UnityExitDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [[WVRMediator sharedInstance] WVRMediator_showTabView:NO];
//    });
}

//- (void)closeBtnClick:(UIButton *)sender {
//
//    NSLog(@"unity_closeBtnClick:");
//
//    // 针对Unity只作为播放器的版本
//    [WVRUnityManager sharedManager].playerHelper.dataParam.position = [[WVRUnityManager sharedManager].unityPlayer getCurrentPosition];
//
//    self.playStatus = UnityPlayerPlayStatusPreparing;
//    [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack = WVRPlayerUnityBackDealExit;
//
//    // 退出unity分屏模式
//    [UnityTools sendMessageToUnity:DESTROY argument:@"true", nil];
//
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UnityExitDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////
////        [[WVRMediator sharedInstance] WVRMediator_showTabView:NO];
////    });
//}

/// 直播关闭按钮点击事件 包括付费节目互踢退出
- (void)liveCloseBtnClick:(UIButton *)sender {
    
    NSLog(@"unity_closeBtnClick:");
    
    self.playStatus = UnityPlayerPlayStatusPreparing;
    
    // 关闭当前原生直播页面或banner
    [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack = WVRPlayerUnityBackDealExit;
    
    // 退出unity分屏模式
    [UnityTools sendMessageToUnity:DESTROY argument:@"true", nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UnityExitDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [[WVRMediator sharedInstance] WVRMediator_showTabView:NO];
//    });
}

- (void)vrModeBtnClick:(UIButton *)sender {
    
    NSLog(@"unity_vrModeBtnClick:");
    
    // 针对Unity只作为播放器的版本
    [WVRUnityManager sharedManager].playerHelper.dataParam.position = [[WVRUnityManager sharedManager].unityPlayer getCurrentPosition];
    
    self.playStatus = UnityPlayerPlayStatusPreparing;
    
    if (self.isFromBanner &&
        [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack != WVRPlayerUnityBackDealExit) {
        [[WVRUnityManager sharedManager] playerUIManager].dealWithUnityBack = WVRPlayerUnityBackDealRotation;
    }
    
    // 退出unity分屏模式
    [UnityTools sendMessageToUnity:DESTROY argument:@"false", nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UnityExitDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [[WVRMediator sharedInstance] WVRMediator_showTabView:NO];
//    });
}

- (void)playBtnClick:(UIButton *)sender {
    
    NSLog(@"unity_playBtnClick:");
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (now - _playClickTime < 0.8) {
        return;
    }
    _playClickTime = now;
    
    if ([self.delegate respondsToSelector:@selector(scheduleHideControls)]) {
        [self.delegate scheduleHideControls];
    }
    
    if (self.playStatus == UnityPlayerPlayStatusComplation) {
        
        // 重新播放
        [UnityTools sendMessageToUnity:RESTART argumentList:nil];
    } else {
        
        if (sender.tag == UnityPlayerPlayStatusPause) {
            
            // 开始播放
            [UnityTools sendMessageToUnity:START argumentList:nil];
            
        } else {
            
            // 暂停播放
            [UnityTools sendMessageToUnity:PAUSE argumentList:nil];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[[WVRUnityManager sharedManager] unityPlayer] isPlaying]) {
            self.playStatus = UnityPlayerPlayStatusPlaying;
        } else if ([[[WVRUnityManager sharedManager] unityPlayer] isPaused]) {
            self.playStatus = UnityPlayerPlayStatusPause;
        }
    });
}

- (void)changeProgress:(long)position {
    
    NSLog(@"unity_changeProgress:");
    
    if ([self.delegate respondsToSelector:@selector(scheduleHideControls)]) {
        [self.delegate scheduleHideControls];
    }
    
    NSString *progress = [NSString stringWithFormat:@"%ld", position];
    
    // 改变播放进度
    [UnityTools sendMessageToUnity:CHANGE_PROGRESS argument:progress, nil];
}

/// 点击热区 0 down，1 up，2 cancel
- (void)hotSpotClick:(NSString *)event {
    
    if ([self.delegate respondsToSelector:@selector(scheduleHideControls)]) {
        [self.delegate scheduleHideControls];
    }
    
    // 改变播放进度
    [UnityTools sendMessageToUnity:@"split_click_hot_spot" argument:event, nil];
}

- (void)showToast {
    if ([self.delegate respondsToSelector:@selector(showToast)]) {
        [self.delegate showToast];
    }
}

- (void)hideToast {
    if ([self.delegate respondsToSelector:@selector(hideToast)]) {
        [self.delegate hideToast];
    }
}

@end
