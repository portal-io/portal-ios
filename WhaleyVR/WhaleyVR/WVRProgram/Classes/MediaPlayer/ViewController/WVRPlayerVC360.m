//
//  WVRPlayerVC360.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVC360.h"
#import "WVRVideoDetailViewModel.h"

@interface WVRPlayerVC360 ()

@property (nonatomic, strong, readonly) WVRVideoDetailViewModel *gVideoDetailViewModel;

@end


@implementation WVRPlayerVC360
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;

#pragma mark - setter getter

- (WVRVideoDetailViewModel *)gVideoDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRVideoDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
}

#pragma mark - overwrite func

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gVideoDetailViewModel gSuccessSignal] subscribeNext:^(WVRVideoDetailViewModel *_Nullable x) {
        @strongify(self);
        [self dealWithDetailData:x.dataModel];
    }];
    
    [[self.gVideoDetailViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        @strongify(self);
        [self httpFailBlock];
    }];
}

-(void)httpFailBlock
{
    SQToastInKeyWindow(kNoNetAlert);
}

- (void)buildInitData {
    if (![WVRReachabilityModel isNetWorkOK]) {
        return;
    }
    [super buildInitData];
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
    self.videoEntity.videoTitle = model.title;
    self.videoEntity.renderTypeStr = model.renderType;
    self.videoEntity.biEntity.totalTime = model.duration.intValue;
    
    self.isFootball = [model isFootball];
    
    [super dealWithDetailData:model];
}

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
