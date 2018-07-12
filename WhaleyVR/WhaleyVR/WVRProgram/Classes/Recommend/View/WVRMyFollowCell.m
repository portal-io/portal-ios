//
//  WVRMyFollowCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyFollowCell.h"

@interface WVRMyFollowCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *countLabel;

@end


@implementation WVRMyFollowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createImageView];
        [self createTitleLabel];
        [self createCountLabel];
    }
    return self;
}

- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(10), adaptToWidth(2), adaptToWidth(125), adaptToWidth(72))];   // adaptToWidth(80)
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)createTitleLabel {
    
    float x = _imageView.bottomX + adaptToWidth(10);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, _imageView.y, self.width - x - adaptToWidth(10), _imageView.height / 2.f)];
    
    label.font = kFontFitForSize(14.5);
    label.textColor = k_Color3;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    _titleLabel = label;
}

- (void)createCountLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.bottomX + adaptToWidth(10), _titleLabel.bottomY, _titleLabel.width, _titleLabel.height)];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color7;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    _countLabel = label;
}

#pragma mark - setter

- (void)setIconUrl:(NSString *)iconUrl {
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:iconUrl] placeholderImage:HOLDER_IMAGE];
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

- (void)setCount:(long)count {
    
    NSString *countStr = [[WVRComputeTool numberToString:count] stringByAppendingString:@"播放"];
    _countLabel.text = countStr;
}

@end
