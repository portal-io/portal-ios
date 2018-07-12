//
//  WVRPlayerVCTopic.m
//  WhaleyVR
//
//  Created by qbshen on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVCTopic.h"
#import "WVRVideoEntityTopic.h"
#import "WVRVideoDetailViewModel.h"
#import "WVRPlayerFullSUIManager.h"

@interface WVRPlayerVCTopic () {
    
    WVRVideoEntityTopic *_videoEntity;
}

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

@end


@implementation WVRPlayerVCTopic
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;
@synthesize playerUI = _tmpPlayerUI;         // 请使用get方法调用

- (WVRPlayerUIManager *)playerUI {
    
    if (!_tmpPlayerUI) {
        _tmpPlayerUI = [[WVRPlayerFullSUIManager alloc] init];
        _tmpPlayerUI.uiDelegate = self;
        
        _tmpPlayerUI.videoEntity = [self videoEntity];
        _tmpPlayerUI.detailBaseModel = [self detailBaseModel];
        _tmpPlayerUI.vPlayer = self.vPlayer;
        _tmpPlayerUI.uiDelegate = self;
        _tmpPlayerUI.gVRLoadingCellViewModel.gHidenBack = NO;
        _tmpPlayerUI.gLodingCellViewModel.gHidenBack = NO;
        [_tmpPlayerUI installAfterSetParams];
    }
    return _tmpPlayerUI;
}
#pragma mark - setter getter

- (void)setVideoEntity:(WVRVideoEntityTopic *)videoEntity {
    
    _videoEntity = videoEntity;
}

- (WVRVideoEntityTopic *)videoEntity {
    
    return _videoEntity;
}

- (WVRVideoDetailViewModel *)gVideoDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRVideoDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
}

#pragma mark - overwrite func

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gVideoDetailViewModel gSuccessSignal] subscribeNext:^(WVRVideoDetailVCModel *_Nullable x) {
        @strongify(self);
        [self dealWithDetailData:x];
    }];
    
    [[self.gVideoDetailViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        
        SQToastInKeyWindow(kNetError);
    }];
}

- (void)checkFreeTime {
    
    if (!self.isCharged) {
        
        long time = [self.vPlayer getCurrentPosition] / 1000;
        if (time >= self.detailBaseModel.freeTime) {
            
            [self.vPlayer destroyPlayer];
            [self.playerUI execFreeTimeOverToCharge:self.detailBaseModel.freeTime];
            self.curPosition = 0.1;
            self.vPlayer.dataParam.position = 0;
        }
    }
}

- (void)requestForDetailData {
    
    self.gVideoDetailViewModel.code = self.videoEntity.sid;
    [self.gVideoDetailViewModel.gDetailCmd execute:nil];
}

- (void)dealWithDetailData:(WVRVideoDetailVCModel *)model {
    
    if (![self.videoEntity isKindOfClass:[WVRVideoEntityTopic class]]) {
        
        _videoEntity = [[WVRVideoEntityTopic alloc] init];
        _videoEntity.sid = model.sid;
        _videoEntity.videoTitle = model.title;
    }
    
    _videoEntity.renderTypeStr = model.renderType;
    
    self.isFootball = [model isFootball];
    
    _videoEntity.biEntity.totalTime = model.duration.intValue;
    
//    WVRMediaDto *selectDto = [model.mediaDtos lastObject];
//    [self videoEntity].currentStandType = selectDto.source;
    
    [super dealWithDetailData:model];
}

- (void)buildInitData {
    if (![WVRReachabilityModel isNetWorkOK]) {
        SQToastInKeyWindow(kNoNetAlert);
        return;
    }
    [super buildInitData];
}

//- (void)registerObserverEvent {
//    [super registerObserverEvent];
//}

#pragma mark - timer

- (void)syncScrubber {
    
    [super syncScrubber];
    
//    long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
    if (![self.vPlayer isPlaying]) {
        
//        [self.playerUI execDownloadSpeedUpdate:speed];
        
    } else {
        long position = [self.vPlayer getCurrentPosition];
        long buffer = [self.vPlayer getPlayableDuration];
        
        [self.playerUI execPositionUpdate:position buffer:buffer duration:[self.vPlayer getDuration]];
    }
}

@end
