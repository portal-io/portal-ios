//
//  WVRPlayerPresenter.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRPlayerPresenterLifeCycle <NSObject>
- (void) onVideoPrepared;
- (void) onBuffering;
- (void) onBuffered;
- (void) onBufferingUpdate;
- (void) onComplete;
- (void) onError;
- (void) onSeekComplete:(long) position;
- (void) start;
- (void) resume;
- (void) pause;
- (void) stop;
- (void) destroy;
@end

@protocol WVRPlayerPresenter <NSObject>
- (void) setPlayData;
- (void) startPlay;
- (void) startPlayWithData;
- (void) playPView;
@end
