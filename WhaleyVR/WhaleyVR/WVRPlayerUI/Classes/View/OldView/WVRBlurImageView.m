//
//  WVRBlurImageView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBlurImageView.h"
//#import "WVRImageTool.h"
#import "UIImage+Extend.h"
#import <SDWebImage/SDWebImage.h>
#import "WVRAppContextHeader.h"

@interface WVRBlurImageView ()

@property (nonatomic) UIVisualEffectView *mBackVisual;

@end


@implementation WVRBlurImageView

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithImage:(UIImage *)image NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithContainerView:(UIView *)containerView imgUrl:(NSString *)imgUrl {
    self = [super initWithFrame:containerView.bounds];
    if (self) {
        
        [self blurImage:imgUrl];
        
        UIView *playerV = nil;
        for (UIView *view in containerView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"WVRPlayerView")]) {
                playerV = view;
                break;
            }
        }
        
        if (playerV) {
            
            [containerView insertSubview:self belowSubview:playerV];
        } else {
            [containerView insertSubview:self atIndex:0];
        }
        
        kWeakSelf(self);
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.size.equalTo(weakself.superview);
        }];
    }
    return self;
}

- (void)blurImage:(NSString *)imgUrl {
    
//    imgUrl = [WVRImageTool parseImageUrlFitScreen:imgUrl];
    
    // 模糊背景图
    self.image = [UIImage imageWithColor:[UIColor blackColor] frame:self.bounds];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    backVisual.frame = self.bounds;
    backVisual.alpha = 1;
    [self addSubview:backVisual];
    self.mBackVisual = backVisual;
    
    [self requestForImage:imgUrl];
}

- (void)requestForImage:(NSString *)imgUrl {
    
    imgUrl = [self wvr_transformZoomURLForString:imgUrl scale:0.2];
    
    NSLog(@"live blurImage imgUrl: %@", imgUrl);
    
    NSURL *url = [NSURL URLWithString:imgUrl];
    
    kWeakSelf(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            
            [weakself setOverlayImage:image];
        }
    }];
}

- (void)setOverlayImage:(UIImage *)overlayImage {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (overlayImage) {
            CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
            
            contentsAnimation.duration = 0.1;
            contentsAnimation.fromValue = self.image;
            contentsAnimation.toValue = overlayImage;
            contentsAnimation.removedOnCompletion = YES;
            contentsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [self.layer addAnimation:contentsAnimation forKey:nil];
            self.image = overlayImage;
        }
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mBackVisual.bounds = self.bounds;
    self.mBackVisual.center = self.center;
}

- (BOOL)playerUINotAutoHide {
    return YES;
}

@end
