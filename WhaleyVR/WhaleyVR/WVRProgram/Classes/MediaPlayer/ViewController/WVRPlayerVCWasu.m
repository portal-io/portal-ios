//
//  WVRPlayerVCWasu.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVCWasu.h"
#import "WVRVideoDetailViewModel.h"

@interface WVRPlayerVCWasu () {
    
    WVRVideoEntityWasuMovie *_videoEntity;
}

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

@end


@implementation WVRPlayerVCWasu
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;

#pragma mark - setter getter

- (void)setVideoEntity:(WVRVideoEntityWasuMovie *)videoEntity {
    
    _videoEntity = videoEntity;
}

- (WVRVideoEntityWasuMovie *)videoEntity {
    
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

- (void)buildInitData {
    if (![WVRReachabilityModel isNetWorkOK]) {
        return;
    }
    [super buildInitData];
}

//- (void)checkFreeTime {
//    
//    if (!self.isCharged) {
//        
//        long time = [self.vPlayer getCurrentPosition] / 1000;
//        if (time >= self.detailBaseModel.freeTime) {
//            
//            [self.vPlayer destroyPlayer];
//            [self.wPlayerView execFreeTimeOverToCharge:self.detailBaseModel.freeTime];
//            self.curPosition = 0.1;
//        }
//    }
//}

- (void)requestForDetailData {
    
    self.gVideoDetailViewModel.code = self.videoEntity.sid;
    [self.gVideoDetailViewModel.gDetailCmd execute:nil];
}

- (void)dealWithDetailData:(WVRItemModel *)model {
    
    if (![self.videoEntity isKindOfClass:[WVRVideoEntityWasuMovie class]]) {
        
        _videoEntity = [[WVRVideoEntityWasuMovie alloc] init];
        _videoEntity.sid = model.linkArrangeValue;
        _videoEntity.videoTitle = model.title;
    }
    
    _videoEntity.renderTypeStr = model.renderType;
    _videoEntity.biEntity.totalTime = ((WVRVideoDetailVCModel *)model).duration.intValue;
    
    [super dealWithDetailData:model];
}

#pragma mark - timer

- (void)syncScrubber {
    
    [super syncScrubber];
    
    long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
    if (![self.vPlayer isPlaying]) {
        
        [self.playerUI execDownloadSpeedUpdate:speed];
        
    } else {
        long position = [self.vPlayer getCurrentPosition];
        long buffer = [self.vPlayer getPlayableDuration];
        
        [self.playerUI execPositionUpdate:position buffer:buffer duration:[self.vPlayer getDuration]];
    }
}

@end
