//
//  WVRSlider.m
//  WhaleyVR
//
//  Created by Bruce on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSlider.h"

@interface WVRSlider ()

@property (nonatomic, weak) CALayer *buffer;

@property (nonatomic, assign) float lastValue;
@property (nonatomic, assign) float bufferValue;

@end


@implementation WVRSlider

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self buildData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self buildData];
    }
    return self;
}

- (void)buildData {
    self.enabled = NO;
    
    [self setThumbImage:[UIImage imageNamed:@"video_slider_point"] forState:UIControlStateNormal];
    self.minimumValue = 0;
    self.maximumValue = 1;
    self.value = 0;
    self.minimumTrackTintColor = k_Color1;
    self.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    CALayer *bufferProgress = [[CALayer alloc] init];
    
    bufferProgress.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    
    [self.layer insertSublayer:bufferProgress atIndex:0];
    _buffer = bufferProgress;
    
    [self addTarget:self action:@selector(starDrag:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(stopDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    
//    [self addTarget:self action:@selector(dragging:) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateBufferWithValue:_bufferValue];
}

#pragma mark - functions

- (void)updatePosition:(long)posi buffer:(long)bu duration:(long)duration {
    
    _currentPosition = posi;
    _useableBuffer = bu;
    _duration = duration;
    
    if (duration <= 0) { return; }
    
    float position = posi / (float)duration;
    
    self.value = position > 1 ? 1 : position;
    
    float bufferValue = bu / (float)duration;
    
    self.bufferValue = bufferValue > 1 ? 1 : bufferValue;
}

- (void)resetWithPlayComplete {
    
    _currentPosition = 0;
    _useableBuffer = 0;
    _duration = 0;
    
    [self setBufferValue:0];
    self.value = 0;
}

- (void)updateBufferWithValue:(float)value {
    
    float width = (self.width - 4) * value;
    self.buffer.frame = CGRectMake(2, self.height * 0.5f - 1, width, 2);
}

#pragma mark - setter

- (void)setBufferValue:(float)bufferValue {
    _bufferValue = bufferValue;
    
    [self updateBufferWithValue:bufferValue];
}

#pragma mark - action

- (void)starDrag:(UISlider *)slider {
    
    self.lastValue = slider.value;
    
    if ([self.realDelegate respondsToSelector:@selector(sliderStartScrubbing:)]) {
        [self.realDelegate sliderStartScrubbing:self];
    }
}

- (void)stopDrag:(UISlider *)slider {
    
    if (self.lastValue == slider.value) { return; }
    
    if ([self.realDelegate respondsToSelector:@selector(sliderEndScrubbing:)]) {
        [self.realDelegate sliderEndScrubbing:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (!self.enabled) { return; }
    
    CGRect t = [self trackRectForBounds: [self bounds]];
    
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
    
    if (fabsf(self.value - v) < 0.05) { return; }
    
    [self setValue:v];
    
    if ([self.realDelegate respondsToSelector:@selector(sliderEndScrubbing:)]) {
        [self.realDelegate sliderEndScrubbing:self];
    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return YES;
//}

//- (CGRect)trackRectForBounds:(CGRect)bounds
//{
//
//}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
////    rect.origin.x = rect.origin.x+15;
//    rect.size.width = rect.size.width+30;
//    rect.size.height = rect.size.height+30;
//    
//    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    return result;
//}

@end
