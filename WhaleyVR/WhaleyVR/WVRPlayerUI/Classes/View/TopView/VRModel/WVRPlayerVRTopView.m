//
//  WVRPlayerVRTopView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVRTopView.h"

@implementation WVRPlayerVRTopView

- (UIView *)topShadow
{
    return nil;
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            [self enableDefaultStatus];
            break;
        case WVRPlayerToolVStatusPrepared:
            [self enablePrepareStatus];
            break;
        case WVRPlayerToolVStatusPlaying:
            [self enablePlayingStatus];
            break;
        case WVRPlayerToolVStatusPause:
        case WVRPlayerToolVStatusUserPause:
            [self enablePauseStatus];
            break;
        case WVRPlayerToolVStatusStop:
            [self enableStopStatus];
            break;
        case WVRPlayerToolVStatusComplete:
            [self enableCompleteStatus];
            break;
        case WVRPlayerToolVStatusError:
            [self enableErrorStatus];
            break;
        case WVRPlayerToolVStatusChangeQuality:
            [self enableChangeQuStatus];
            break;
        case WVRPlayerToolVStatusSliding:
            [self enableSlidingStatus];
            break;
        default:
            break;
    }
}

- (void)updatePlayBtnStatus:(BOOL)isPlaying {
    
    int status = isPlaying ? 1 : 0;
    if (self.startBtn.tag == status) { return; }
    
    self.startBtn.tag = status;
    self.startBtn.selected = isPlaying;
}

- (void)enableNotClockStatus {
    self.hidden = NO;
    //    if (self.gIsPlay) {
    //        [self enablePlayingStatus];
    //    } else {
    //
    //    }
}

- (void)enableDefaultStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;

}

- (void)enablePrepareStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = YES;
    
}

- (void)enablePlayingStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = YES;
    
}

- (void)enablePauseStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;

}

- (void)enableStopStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
    
}

- (void)enableCompleteStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
}

- (void)enableErrorStatus {
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;

}

- (void)enableChangeQuStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = NO;
    
}

- (void)enableSlidingStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;

}

- (void)enableHidenStatus {
    
    self.hidden = YES;
}

- (void)enableShowStatus {
    
    self.hidden = NO;
}

#pragma mark - 子类调用

- (UIColor *)enableColor {
    
    return [UIColor whiteColor];
}

- (UIColor *)disableColor {
    
    return [UIColor colorWithWhite:0.8 alpha:1];
}

- (IBAction)playBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([self.gViewModel.delegate respondsToSelector:@selector(playOnClick:)])
    {
        [self.gViewModel.delegate playOnClick:sender.selected];
    }
}

-(void)updateHidenStatus:(BOOL)isHiden
{
    
}
@end
