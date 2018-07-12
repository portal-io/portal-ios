//
//  WVRSmallPlayerPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSmallPlayerPresenter.h"
//#import "WVRSmallPlayerViewPresenter.h"
//#import "WVRLivePlayerViewPresenter.h"
#import "WVRLiveRecBannerItemView.h"
#import "WVRVideoDetailVCModel.h"

#import "WVRMediaModel.h"
#import "WVRParseUrl.h"
#import "WVRVideoEntity.h"
#import "WVRVideoDetailViewModel.h"
#import "WVRLiveDetailViewModel.h"
#import "WVRLiveItemModel.h"
#import "WVRPlayerBannerController.h"
#import "WVRPlayerBannerLiveController.h"
#import "WVRVideoEntityLive.h"

@interface WVRSmallPlayerPresenter ()<WVRPlayerBannerProtocol>

@property (nonatomic, strong) WVRPlayerBannerController * gCurPlayBannerController;
@property (nonatomic, strong) WVRPlayerBannerController * gPlayBannerController;
@property (nonatomic, strong) WVRPlayerBannerLiveController * gPlayBannerLiveController;

@property (nonatomic, strong) NSMutableSet * gShouldPauseSet;
@property (nonatomic, assign) BOOL mCanPlay;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) WVRLiveDetailViewModel * gLiveDetailViewModel;

@property (nonatomic, assign) BOOL curIsFootball;

@property (nonatomic, strong) WVRItemModel *detailBaseModel;

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

@property (nonatomic, copy) void(^detailSuccessBlock)(void);
@property (nonatomic, copy) void(^detailFailBlock)(void);

@property (nonatomic, weak  ) WVRItemModel *tmpItemModel;
@property (nonatomic, assign) NSInteger tmpIndex;
//@property (nonatomic, assign) BOOL isReloading;

//@property (nonatomic, assign) BOOL isFirstReload;
@end


@implementation WVRSmallPlayerPresenter
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;

+ (instancetype)shareInstance {
    
    static WVRSmallPlayerPresenter * presenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        presenter = [WVRSmallPlayerPresenter new];
        [presenter initData];
        
    });
    return presenter;
}

+ (instancetype)createPresenter:(id)createArgs {
    
    WVRSmallPlayerPresenter * p = [WVRSmallPlayerPresenter new];
    return p;
}

- (void)initData {
//    self.isFirstReload = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NAME_NOTF_PLAYER_ISRELASE_COMPLETE object:nil];
    if (!self.gShouldPauseSet) {
        self.gShouldPauseSet = [NSMutableSet new];
    }
}

-(WVRPlayerBannerController *)gPlayBannerController
{
    if (!_gPlayBannerController) {
        if (!self.contentView) {
            return nil;
        }
        _gPlayBannerController = [[WVRPlayerBannerController alloc] initWithContentView:self.contentView delegate:self];
        //主动调用self.view UIViewController 才会调用loadView ,viewDidLoad 等生命周期函数
//        _gPlayBannerController.view.backgroundColor = [UIColor clearColor];
//        _gPlayBannerController.view.hidden = YES;
    }
    return _gPlayBannerController;
}

-(WVRPlayerBannerLiveController *)gPlayBannerLiveController
{
    if (!_gPlayBannerLiveController) {
        if (!self.contentView) {
            return nil;
        }
        _gPlayBannerLiveController = [[WVRPlayerBannerLiveController alloc] initWithContentView:self.contentView delegate:self];
        //主动调用self.view UIViewController 才会调用loadView ,viewDidLoad 等生命周期函数
//        _gPlayBannerLiveController.view.backgroundColor = [UIColor clearColor];
//        _gPlayBannerLiveController.view.hidden = YES;
    }
    return _gPlayBannerLiveController;
}

- (void)reloadData {
    
//    if (!self.isReloading&&!self.isFirstReload) {
//        NSLog(@"bannerLog:没有要起播的Banner");
//        return;
//    }
//    self.isFirstReload = NO;
//    self.isReloading = NO;
    if (![WVRReachabilityModel sharedInstance].isWifi){
        NSLog(@"bannerLog:非wifi下不播放");
        return;
    }
    if (![self canPlay]) {
        NSLog(@"bannerLog:player not canPlay");
        
        return;
    }
    
    
    if (self.isLive) {
        if (self.itemModel.liveStatus != WVRLiveStatusPlaying) {
            NSLog(@"bannerLog:直播不是直播中状态");
            return;
        }
        WVRVideoEntityLive * ve = (WVRVideoEntityLive *)self.gPlayBannerLiveController.videoEntity;
        if (!ve) {
            ve = [[WVRVideoEntityLive alloc] init];
        }
        ve.sid  = self.itemModel.linkArrangeValue;
        ve.videoTitle = self.itemModel.title;
        ve.streamType = STREAM_VR_LIVE;
        self.gPlayBannerLiveController.videoEntity = ve;
        self.gCurPlayBannerController = (WVRPlayerBannerController*)self.gPlayBannerLiveController;
    }else{
        WVRVideoEntity * ve = self.gPlayBannerController.videoEntity;
        if (!ve) {
            ve = [[WVRVideoEntity alloc] init];
        }
        ve.sid  = self.itemModel.linkArrangeValue;
        ve.videoTitle = self.itemModel.name;
        if ([self.itemModel.programType isEqualToString:PROGRAMTYPE_MORETV_TV] || [self.itemModel.programType isEqualToString:PROGRAMTYPE_MORETV_TV]) {
            ve.streamType = STREAM_2D_TV;
        }else if([self.itemModel.videoType isEqualToString:VIDEO_TYPE_3D]){
            ve.streamType = STREAM_3D_WASU;
        }else{
            ve.streamType = STREAM_VR_VOD;
        }
        self.gPlayBannerController.videoEntity = ve;
        self.gCurPlayBannerController = self.gPlayBannerController;
    }
    [self.gCurPlayBannerController updateContentView:self.contentView];
    self.gCurPlayBannerController.view.hidden = YES;
    [self.gCurPlayBannerController startLoadPlay];
    
}

- (void)restartForLaunch {
    
    [self.gCurPlayBannerController restartForLaunch];
}



//- (UIView *)getView{
//    return self.mCurPlayerP.gPlayerBannerView;
//}

- (void)updateFrame:(CGRect)frame {
    
//    self.mCurPlayerP.gPlayerBannerView.frame = frame;
}
//stop 和start banner scrollView 上下滑动时使用
- (void)stop {
    
    [self.gCurPlayBannerController stop];
}

- (void)start {
    
    if (self.canPlay) {
        if ([self.gCurPlayBannerController playerUI].gIsUserPause) {
            return;
        }
        [self.gCurPlayBannerController start];
    }
}

- (void)destroy {
    [self.gCurPlayBannerController destory];
}

//- (void)destroyForLauncher {
//
////    [self.gCurPlayBannerController destroyForUnity];
//}

- (BOOL)isPlaying {
    
    return [self.gCurPlayBannerController.vPlayer isPlaying];
}

- (BOOL)isPaused {
    
    return self.gCurPlayBannerController.vPlayer.isPaused;
}

- (BOOL)canPlay {
    
    return self.mCanPlay;
}

- (void)updateCanPlay:(BOOL)canPlay {
    self.mCanPlay = canPlay;
}

- (void)responseCurPage:(NSInteger)pageNumber itemModel:(WVRItemModel *)itemModel contentView:(UIView*)contentView {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];    // 可以成功取消全部。
    [self.gCurPlayBannerController destory];
    self.curIndex ++;
    self.contentView = contentView;
    self.isLive = (itemModel.linkType_ == WVRLinkTypeLive);
    
    if (itemModel.isChargeable) {
        NSLog(@"bannerLog:需要付费");
        return;
    }
    self.itemModel = itemModel;
//    self.isReloading = YES;

//    if (self.gCurPlayBannerController.vPlayer.isGLKDealloc||self.isFirstReload) {
//        if(self.isFirstReload){
//            NSLog(@"bannerLog:第一次reload直接起播Banner");
//        }else{
//            NSLog(@"bannerLog:播放器已经释放直接起播Banner");
//        }
        [self reloadData];
//    }else{
//        NSLog(@"bannerLog: 等待播放器释放后起播的Banner。。。");
//    }
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];    // 清空schedule队列
//    [self performSelector:@selector(reloadData) withObject:nil afterDelay:2];
    
}


- (BOOL)shouldPause {
    
//    NSLog(@"shouldpause get code:%@", self.itemModel.code);
    BOOL contain = [self.gShouldPauseSet containsObject:self.itemModel.code];
    return contain;
}

- (void)setShouldPause:(BOOL)shouldPause {
    
//    NSLog(@"shouldpause set code:%@", self.itemModel.code);
    if (self.itemModel.code.length == 0) {
        return;
    }
    if (shouldPause) {
        [self.gShouldPauseSet addObject:self.itemModel.code];
    } else {
        [self.gShouldPauseSet removeObject:self.itemModel.code];
    }
}

-(BOOL)isLaunch
{
    BOOL r = self.gCurPlayBannerController.playerUI.isGoUnity||self.gCurPlayBannerController.playerUI.isGoUnityFootball;
    return r;
}

- (void)dealloc {
    
    DDLogInfo(@"");
    self.curIndex = -1;
}

#pragma mark - WVRPlayerBannerProtocol
-(BOOL)onVideoPrepared
{
    if (self.shouldPause) {
        [self stop];
    }
    return !self.shouldPause;
}
@end
