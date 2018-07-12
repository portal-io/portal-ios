//
//  WVRSwipeableView.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "ZLSwipeableView.h"

@interface WVRSwipeableView : ZLSwipeableView
- (void)animateViewSwipping:(UIView *)view
                      index:(NSUInteger)index
                      views:(NSArray<UIView *> *)views
              swipeableView:(ZLSwipeableView *)swipeableView
                      scale:(CGFloat)scale;
@end
