//
//  WVRCircleProgressButton.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRCircleProgressButton.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)

@interface WVRCircleProgressButton()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, copy)   WVRCircleProgressBlock finishBlock;

@property (nonatomic, assign) CGFloat    animationDuration;

@end


@implementation WVRCircleProgressButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.layer addSublayer:self.trackLayer];
    }
    return self;
}

- (void)dealloc {
    
    DDLogInfo(@"WVRCircleProgressButton dealloc");
}

- (UIBezierPath *)bezierPath {
    
    if (!_bezierPath) {
        
        CGFloat width = CGRectGetWidth(self.frame)/2.0f;
        CGFloat height = CGRectGetHeight(self.frame)/2.0f;
        CGPoint centerPoint = CGPointMake(width, height);
        float radius = CGRectGetWidth(self.frame)/2;
        
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                     radius:radius
                                                 startAngle:degreesToRadians(-90)
                                                   endAngle:degreesToRadians(270)
                                                  clockwise:YES];
    }
    return _bezierPath;
}

- (CAShapeLayer *)trackLayer {
    
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.frame = self.bounds;
        _trackLayer.fillColor = self.fillColor.CGColor ?: [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        _trackLayer.lineWidth = self.lineWidth ?: 2.f;
        _trackLayer.strokeColor = self.trackColor.CGColor ?: [UIColor grayColor].CGColor;
        _trackLayer.strokeStart = 0.f;
        _trackLayer.strokeEnd = 1.f;
        
        _trackLayer.path = self.bezierPath.CGPath;
    }
    return _trackLayer;
}

- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = self.lineWidth ? self.lineWidth : 2.f;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeColor = self.progressColor.CGColor ?: [UIColor redColor].CGColor;
        _progressLayer.strokeStart = 0.f;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.animationDuration;
        pathAnimation.fromValue = @(0.0);
        pathAnimation.toValue = @(1.0);
        pathAnimation.removedOnCompletion = YES;
        pathAnimation.delegate = self;
        [_progressLayer addAnimation:pathAnimation forKey:nil];
        
        _progressLayer.path = _bezierPath.CGPath;
    }
    return _progressLayer;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag && self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark - external func

- (void)startAnimationDuration:(CGFloat)duration completionBlock:(WVRCircleProgressBlock)block {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.finishBlock = block;
        self.animationDuration = duration > 0 ? duration : 1;
        [self.layer addSublayer:self.progressLayer];
    });
}

@end
