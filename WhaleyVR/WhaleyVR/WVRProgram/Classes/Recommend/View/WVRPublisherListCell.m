//
//  WVRPublisherListCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPublisherListCell.h"

@interface WVRPublisherListCell ()

@property (nonatomic, assign) long duration;
@property (nonatomic, assign) long playCount;

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *introLabel;

@end


@implementation WVRPublisherListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self createImageView];
        [self createTitleLabel];
        [self createIntroLabel];
    }
    return self;
}

#pragma mark - UI

- (void)createImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(10), adaptToWidth(9), self.width - 2 * adaptToWidth(10), adaptToWidth(195))];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [self addSubview:imageView];
    
    _imageView = imageView;
}

- (void)createTitleLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = kFontFitForSize(15);
    label.textColor = k_Color3;
    label.text = @"标题";
    [label sizeToFit];
    float height = label.height;
    label.frame = CGRectMake(_imageView.x, _imageView.bottomY + adaptToWidth(7), _imageView.width, height);
    
    [self addSubview:label];
    _titleLabel = label;
}

- (void)createIntroLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color6;
    label.text = @"描述";
    [label sizeToFit];
    float height = label.height;
    label.frame = CGRectMake(_titleLabel.x, _titleLabel.bottomY + adaptToWidth(7), _titleLabel.width, height);
    
    [self addSubview:label];
    _introLabel = label;
}

#pragma mark - setter

- (void)setPicUrl:(NSString *)picUrl {
    
    [self.imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:picUrl] placeholderImage:HOLDER_IMAGE];
}

- (void)setTitle:(NSString *)title {
    
    [self.titleLabel setText:title];
}

- (void)setDuration:(long)duration AndPlayCount:(long)playCount {
    
    NSString *time = [WVRComputeTool durationToString:duration];
    NSString *count = [WVRComputeTool numberToString:playCount];
    
    NSString *str = [NSString stringWithFormat:@"%@ | %@播放", time, count];
    
    [self.introLabel setText:str];
}

@end
