//
//  WVRSwipeableView.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSwipeableView.h"
#import "WVRSwipeSubView.h"

@interface WVRSwipeableView ()<ZLSwipeableViewAnimator>

@end
@implementation WVRSwipeableView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.viewAnimator = self;
}

- (void)animateView:(UIView *)view
              index:(NSUInteger)index
              views:(NSArray<UIView *> *)views
      swipeableView:(ZLSwipeableView *)swipeableView {
    if (index==self.numberOfActiveViews-1) {
        index = index-1;
    }
    CGFloat degree = 0;//sin(0.5 * index);
    NSTimeInterval duration = 0.4;
    CGFloat x = 20.0f*index;
    CGPoint offset = CGPointMake(x, CGRectGetHeight(swipeableView.bounds) * 0.3);
    CGRect frame = view.frame;
    frame.origin.x = x;
    frame.size.width = swipeableView.frame.size.width-x*2;
    frame.size.height = swipeableView.frame.size.height;
    frame.origin.y = -(index * 10.0);
    view.frame = frame;
//    WVRSwipeSubView * cur = (WVRSwipeSubView*)view;
//    [cur updateLayFrame];
    CGPoint translation = CGPointMake(degree * 10.0, -(index * 10.0));
    [self rotateAndTranslateView:view
                       forDegree:degree
                     translation:translation
                        duration:duration
              atOffsetFromCenter:offset
                   swipeableView:swipeableView];
}

- (void)animateViewSwipping:(UIView *)view
                      index:(NSUInteger)index
                      views:(NSArray<UIView *> *)views
              swipeableView:(ZLSwipeableView *)swipeableView
                      scale:(CGFloat)scale
{
    CGFloat curScale = index*(1-scale);
    if (index==self.numberOfActiveViews-1) {
        return;
    }
    CGFloat degree = 0;//sin(0.5 * index);
    NSTimeInterval duration = 0.4;
    CGFloat x = 20.0f*curScale;
    CGPoint offset = CGPointMake(x, CGRectGetHeight(swipeableView.bounds) * 0.3);
    CGRect frame = view.frame;
    frame.origin.x = x;
    frame.size.width = swipeableView.frame.size.width-x*2;
    frame.size.height = swipeableView.frame.size.height;
    CGFloat y = -(10.0*curScale);
    frame.origin.y = y;
    view.frame = frame;
//    WVRSwipeSubView * cur = (WVRSwipeSubView*)view;
//    [cur updateLayFrame];
    CGPoint translation = CGPointMake(degree * 10.0, y);
    [self rotateAndTranslateView:view
                       forDegree:degree
                     translation:translation
                        duration:duration
              atOffsetFromCenter:offset
                   swipeableView:swipeableView];
}

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return radians * 180 / M_PI;
}

- (void)rotateAndTranslateView:(UIView *)view
                     forDegree:(float)degree
                   translation:(CGPoint)translation
                      duration:(NSTimeInterval)duration
            atOffsetFromCenter:(CGPoint)offset
                 swipeableView:(ZLSwipeableView *)swipeableView {
    float rotationRadian = [self degreesToRadians:degree];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         view.center = [swipeableView convertPoint:swipeableView.center
                                                          fromView:swipeableView.superview];
                         CGAffineTransform transform =
                         CGAffineTransformMakeTranslation(offset.x, offset.y);
                         transform = CGAffineTransformRotate(transform, rotationRadian);
                         transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
                         transform =
                         CGAffineTransformTranslate(transform, translation.x, translation.y);
                         view.transform = transform;
                     }
                     completion:nil];
}

@end
