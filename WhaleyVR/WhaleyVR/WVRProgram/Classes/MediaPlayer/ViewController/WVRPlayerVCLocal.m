//
//  WVRPlayerVCLocal.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVCLocal.h"

@interface WVRPlayerVCLocal () {
    
    WVRVideoEntityLocal *_videoEntity;
}

@end


@implementation WVRPlayerVCLocal

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - setter getter

- (void)setVideoEntity:(WVRVideoEntityLocal *)videoEntity {
    
    _videoEntity = videoEntity;
}

- (WVRVideoEntityLocal *)videoEntity {
    
    return _videoEntity;
}

- (BOOL)isCharged {
    
    return YES;
}

#pragma mark - overwrite func

- (void)buildInitData {
    
//    self.vPlayer.dataParam.framOritation = ((WVRVideoEntityLocal *)self.videoEntity).oritaion;
    
    [super buildInitData];
}

// 无需记录历史
- (void)recordHistory {}

#pragma mark - timer

- (void)syncScrubber {
    [super syncScrubber];
    
    long position = [self.vPlayer getCurrentPosition];
    
    [self.playerUI execPositionUpdate:position buffer:0 duration:[self.vPlayer getDuration]];
}

- (void)setupRequestRAC {
    
}
    
@end
