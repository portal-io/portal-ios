//
//  WVRSlider.h
//  WhaleyVR
//
//  Created by Bruce on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRSliderDelegate <NSObject>

- (void)sliderStartScrubbing:(UISlider *)sender;
- (void)sliderEndScrubbing:(UISlider *)sender;

@end


@interface WVRSlider : UISlider

@property (nonatomic, weak) id<WVRSliderDelegate> realDelegate;

@property (nonatomic, assign) long currentPosition;
@property (nonatomic, assign) long useableBuffer;
@property (nonatomic, assign) long duration;

- (void)updatePosition:(long)posi buffer:(long)bu duration:(long)duration;

// 播放结束后重置状态
- (void)resetWithPlayComplete;

@end
