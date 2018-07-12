//
//  WVRNoneFollowView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNoneFollowView.h"

@interface WVRNoneFollowView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *remainLabel;

@end


@implementation WVRNoneFollowView

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - kTabBarHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createImageView];
        [self createRemindLabel];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)createImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, adaptToWidth(160), adaptToWidth(180), adaptToWidth(165))];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.centerX = self.width / 2.f;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"myFollow_icon_noneFollow"];
    
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)createRemindLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"你还没有关注任何人哦";
    label.font = kFontFitForSize(15);
    label.textColor = k_Color6;
    [label sizeToFit];
    
    label.centerX = self.width / 2.f;
    label.y = self.imageView.bottomY + adaptToWidth(25);
    
    [self addSubview:label];
    _remainLabel = label;
}

@end
