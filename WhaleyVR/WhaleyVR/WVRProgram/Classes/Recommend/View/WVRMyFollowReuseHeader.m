//
//  WVRMyFollowReuseHeader.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyFollowReuseHeader.h"
#import "WVRRecommendStyleHeader.h"

@interface WVRMyFollowReuseHeader ()

@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@end


@implementation WVRMyFollowReuseHeader

// width:
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createLine];
        [self createImageView];
        [self createTitleLabel];
        [self createtimeLabel];
        [self createBtn];
    }
    return self;
}

- (void)createLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, HEIGHT_SPLITE_LINE)];
    line.backgroundColor = k_Color10;
    
    [self addSubview:line];
    _line = line;
}

- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(10), _line.bottomY + adaptToWidth(13), adaptToWidth(45), adaptToWidth(45))];
    
    imgV.clipsToBounds = YES;
    imgV.layer.cornerRadius = imgV.height / 2.f;
    imgV.userInteractionEnabled = YES;
    imgV.layer.borderWidth = fitToWidth(0.6);
    imgV.layer.borderColor = k_Color9.CGColor;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)createTitleLabel {
    
    float x = _imageView.bottomX + adaptToWidth(10);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, _imageView.y, self.width - x - adaptToWidth(10), _imageView.height / 2.f)];
    
    label.font = kFontFitForSize(15);
    label.textColor = k_Color3;
    
    [self addSubview:label];
    _titleLabel = label;
}

- (void)createtimeLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.bottomX + adaptToWidth(10), _titleLabel.bottomY, _titleLabel.width, _titleLabel.height)];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color7;
    
    [self addSubview:label];
    _timeLabel = label;
}

- (void)createBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.backgroundColor = [UIColor clearColor];
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

#pragma mark - action

- (void)buttonClick:(UIButton *)sender {
    
    if ([self.realDelegate respondsToSelector:@selector(headerClickAtIndex:)]) {
        [self.realDelegate headerClickAtIndex:self.tag];
    }
}

#pragma mark - setter

- (void)setIconUrl:(NSString *)iconUrl {
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:iconUrl] placeholderImage:[UIImage imageNamed:@"default_publisher_icon"]];
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

- (void)setTime:(long)time {
    
    NSString *countStr = [WVRComputeTool timeLeftNow:time];
    _timeLabel.text = countStr;
}

@end
