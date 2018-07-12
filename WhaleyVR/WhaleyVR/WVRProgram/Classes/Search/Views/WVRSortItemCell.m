//
//  WVRSortItemCell.m
//  WhaleyVR
//
//  Created by Snailvr on 16/7/23.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSortItemCell.h"

@implementation WVRSortItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // WVRCornerImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imageView];                        // 图片比例为 180:100
        _imageView = imageView;
        
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = k_Color3;
        label.font = kFontFitForSize(13);
        [self addSubview:label];
        _titleLabel = label;
        
        _titleLabel.x = kCellTitleDistance;
        _titleLabel.width = self.width - _titleLabel.x;
        _titleLabel.height = adaptToWidth(15);
        
        UILabel *detail = [[UILabel alloc] init];
        detail.textColor = [UIColor colorWithHex:0x898989];
        detail.font = kFontFitForSize(11.5);
        
        [self addSubview:detail];
        _detailLabel = detail;
        
        
//        UILabel *score = [[UILabel alloc] init];
//        score.textColor = [UIColor redColor];
//        score.textAlignment = NSTextAlignmentCenter;
//        
//        [imageView addSubview:score];
//        _scoreLabel = score;
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineBGColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right);
            make.top.equalTo(line.superview);
            make.width.mas_equalTo(kListCellDistance);
            make.height.equalTo(line.superview).offset(1);
        }];
        
//        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(45, 22));
//            make.right.equalTo(_scoreLabel.superview);
//            make.bottom.equalTo(_scoreLabel.superview).offset(-10);
//        }];
    }
    
    return self;
}

- (void)setStyle:(WVRItemCellStyle)style {
    _style = style;
    
    float centerY = self.height - kCellLogoHeight/2.0;  // 有副标题时专用变量
    
    if (style == WVRItemCellStyleMovie) {             // 3D电影，不显示副标题，  以后可能会显示评分
        
        _titleLabel.font = kFontFitForSize(12.5);
        _imageView.size = CGSizeMake(self.width, self.height - kTitleHeight);
        
        _detailLabel.hidden = YES;
        _titleLabel.centerY = self.height - kTitleHeight/2.0;
        
    } else {
        
        _titleLabel.font = kFontFitForSize(13);
        _imageView.size = CGSizeMake(self.width, self.height - kCellLogoHeight);
        
        _detailLabel.hidden = NO;
        _titleLabel.bottomY = centerY;
    }
    
    _detailLabel.frame = CGRectMake(_titleLabel.x , centerY + adaptToWidth(4), _titleLabel.width, adaptToWidth(12));
    
}

@end
