//
//  WVRReviewCell.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/5.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 直播回顾cell

#import "WVRReviewCell.h"
#import "WVRComputeTool.h"
#import "WVRImageTool.h"
#import "WVRWidgetColorHeader.h"

@interface WVRReviewCell ()

/// 标题
@property (nonatomic, weak) UILabel     *titleLabel;
/// 图片
@property (nonatomic, weak) UIImageView *imageView;
/// 描述
@property (nonatomic, weak) UILabel     *descLabel;
/// 专题标签 xx部
@property (nonatomic, weak) UILabel     *tagLabel;

@end


@implementation WVRReviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, floorf(self.width/7.0 * 4))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [self addSubview:imageView];
        _imageView = imageView;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCellTitleDistance, imageView.bottomY + 6, self.width - kCellTitleDistance, fitToWidth(15))];
        label.font = kFontFitForSize(13.5);
        label.textColor = UIColorFromRGB(0x2a2a2a);
        [self addSubview:label];
        _titleLabel = label;
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.x, label.bottomY + 5, label.width, label.height)];
        descLabel.font = kFontFitForSize(11.5);
        descLabel.textColor = [UIColor colorWithHex:0x898989];
        [self addSubview:descLabel];
        _descLabel = descLabel;
        
        
        // 关联资源数量
        UILabel *markLabel = [[UILabel alloc] init];
        markLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25f];
        markLabel.font = kBoldFontFitSize(12.5);
        markLabel.textColor = [UIColor whiteColor];
        markLabel.textAlignment = NSTextAlignmentCenter;
        markLabel.clipsToBounds = YES;
        markLabel.layer.borderWidth = 2;
        markLabel.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
        
        [self addSubview:markLabel];
        _tagLabel = markLabel;
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineBGColor;
        [self addSubview:line];
        
        kWeakSelf(self);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.mas_right);
            make.top.equalTo(weakself);
            make.width.mas_equalTo(kListCellDistance);
            make.height.equalTo(weakself);
        }];
    }
    
    return self;
}


- (void)setModel:(WVRItemModel *)model isHeader:(BOOL)isHeader{
    
    if (_model != model) {
        
        _model = model;
        
        _titleLabel.text = model.name;
        
        
        _titleLabel.frame = CGRectMake(fitToWidth(15.0f), _imageView.height+fitToWidth(10.0f), self.width - 2*fitToWidth(15.0f), adaptToWidth(13.0f));
        
        if (isHeader) {
            [self setHeaderModel:model];
        } else {
            [self setDefaultCellModel:model];
        }
    }
}

-(void)setHeaderModel:(WVRItemModel *)model
{
    _imageView.frame = CGRectMake(0, 0, self.width, fitToWidth(211.f));
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:model.scaleThubImage? model.scaleThubImage:[WVRImageTool parseImageUrl:model.thubImageUrl scaleSize:_imageView.size]] placeholderImage:HOLDER_IMAGE];
    
    _tagLabel.text = [NSString stringWithFormat:@"%@部", model.unitConut];
    
    CGSize size = [WVRComputeTool sizeOfString:_tagLabel.text Size:CGSizeMake(SCREEN_WIDTH/2, 40) Font:_tagLabel.font];
    _tagLabel.size = CGSizeMake(size.width + adaptToWidth(14), size.height + adaptToWidth(6));
    _tagLabel.layer.cornerRadius = _tagLabel.height/2.0;
    _titleLabel.font = kFontFitForSize(13.5);
    _descLabel.font = kFontFitForSize(11.5);
    _titleLabel.y = _imageView.bottomY + fitToWidth(9.f);
    _tagLabel.bottomY = _imageView.bottomY - adaptToWidth(10);
    _tagLabel.bottomX = self.width - adaptToWidth(15);
    
    _tagLabel.hidden = NO;
    _descLabel.hidden = NO;
    
    _descLabel.text = model.subTitle;
    
    //            _titleLabel.bottomY = centerY;
    _descLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.bottomY+fitToWidth(5.0f), _titleLabel.width, adaptToWidth(11.0f));
    _descLabel.font = kFontFitForSize(11.5);
}

-(void)setDefaultCellModel:(WVRItemModel *)model
{
    _imageView.frame = CGRectMake(0, 0, self.width, fitToWidth(105.f));
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:model.scaleThubImage? model.scaleThubImage:[WVRImageTool parseImageUrl:model.thubImageUrl scaleSize:_imageView.size]] placeholderImage:HOLDER_IMAGE];
    
    _titleLabel.y = _imageView.height+fitToWidth(9.0f);
    _titleLabel.height = fitToWidth(13.0f);
    _titleLabel.font = kFontFitForSize(13.5);
    _tagLabel.hidden = YES;
    _descLabel.hidden = NO;
    
    _descLabel.text = model.subTitle;
    
    //            _titleLabel.bottomY = centerY;
    _descLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.bottomY+fitToWidth(5.0f), _titleLabel.width, adaptToWidth(11.0f));
    _descLabel.font = kFontFitForSize(11.5);
}

@end
