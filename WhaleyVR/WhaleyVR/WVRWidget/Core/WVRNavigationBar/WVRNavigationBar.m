//
//  WVRNavigationBar.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNavigationBar.h"
#import "WVRAppContextHeader.h"

@interface WVRNavigationBar ()

@property (nonatomic, weak) UIView *overlay;

@end


@implementation WVRNavigationBar

- (instancetype)init {
    
    // adjustForIOS11
    CGRect rect = CGRectMake(0, kStatuBarHeight, SCREEN_WIDTH, 44);
    if (kSystemVersion < 11) {
        rect = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    
    self = [super initWithFrame:rect];
    if (self) {
        
        [self setupTransparencyEffect];
        [self configTitleLabel];
        [self configOverlay];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    
    return nil;
}

- (void)setOverlayDiaphaneity:(float)alpha {
    
    self.tintColor = [UIColor colorWithWhite:1 - alpha alpha:1];
//    self.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    
    self.overlay.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    [self setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:alpha] }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self configOverlay];
}

#pragma mark - private

/// 设置透明效果
- (void)setupTransparencyEffect {
    
    self.shadowImage = [[UIImage alloc] init];
    self.tintColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}

- (void)configTitleLabel {
    
    [self setTitleTextAttributes:
     @{ NSFontAttributeName:kNavTitleFont,
        NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0] }];
}

- (void)configOverlay {
    
    if (_overlay) {
        
        [self sendSubviewToBack:_overlay];
        
    } else {
        
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        
        // insert an overlay into the view hierarchy
        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -kStatuBarHeight, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + kStatuBarHeight)];
        overlay.backgroundColor = [UIColor clearColor];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:overlay atIndex:0];
        _overlay = overlay;
    }
}

@end

@interface WVRDetailNavigationBar ()

@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end


@implementation WVRDetailNavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addGradientLayer];
    }
    return self;
}

/// 设置渐变效果
- (void)addGradientLayer {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.overlay.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],           // 0.8
                            (id)[[UIColor colorWithWhite:0 alpha:0] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    [self.overlay.layer insertSublayer:gradientLayer atIndex:0];
    _gradientLayer = gradientLayer;
}

@end

