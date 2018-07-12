//
//  WVRShowFieldCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShowFieldCell.h"
#import "YYText.h"
#import "WVRShowFieldRoomModel.h"

@interface WVRShowFieldCell ()

@property (nonatomic, assign) float gap;
@property (nonatomic, weak) UIView *line;               // 分割线
@property (nonatomic, weak) UIImageView *iconView;      // 头像
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic, weak) UILabel *viewCountLabel;
@property (nonatomic, weak) UIImageView *posterImgView;
@property (nonatomic, weak) YYLabel *statusLabel;       // 直播中等状态

@end


@implementation WVRShowFieldCell

#pragma mark - init UI

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
        [self configSubviews];
    }
    return self;
}

- (void)configSelf {
    
    self.gap = adaptToWidth(10);
    self.backgroundColor = [UIColor whiteColor];
}

- (void)configSubviews {
    
    [self createLine];
    [self createIconView];
    [self createTitleLabel];
    [self createIntroLabel];
    [self createViewCountLabel];
    [self createPosterImgView];
    [self createStatusLabel];
}

#pragma mark - UI

- (void)createLine {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, adaptToWidth(6))];
    view.backgroundColor = k_Color10;
    
    [self addSubview:view];
    _line = view;
}

- (void)createIconView {
    
    float width = adaptToWidth(45);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(_gap, _line.bottomY + adaptToWidth(7.5), width, width)];
    
//    imageV.clipsToBounds = YES;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.cornerRadius = width/2.f;
    imageV.layer.masksToBounds = YES;
    
    [self addSubview:imageV];
    self.iconView = imageV;
}

- (void)createTitleLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.bottomX + _gap, 0, self.width - adaptToWidth(80), 20)];
    
    label.text = @"微鲸VR";
    label.textColor = k_Color3;
    label.font = [WVRAppModel fontFitForSize:15];
    
    CGSize size = [WVRComputeTool sizeOfString:label.text Size:CGSizeMake(800, 800) Font:label.font];
    label.height = size.height + adaptToWidth(3);
    
    label.bottomY = _iconView.centerY - 1;
    
    [self addSubview:label];
    _titleLabel = label;
}

- (void)createIntroLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.bottomX + _gap, 0, self.width - adaptToWidth(80), 20)];
    
    label.text = @"微鲸VR";
    label.textColor = k_Color7;
    label.font = [WVRAppModel fontFitForSize:12];
    
    CGSize size = [WVRComputeTool sizeOfString:label.text Size:CGSizeMake(800, 800) Font:label.font];
    label.height = size.height + adaptToWidth(3);
    
    label.y = _iconView.centerY + 1;
    
    [self addSubview:label];
    _introLabel = label;
}

- (void)createViewCountLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [WVRAppModel fontFitForSize:15];
    label.textColor = k_Color4;
    
    [self addSubview:label];
    _viewCountLabel = label;
}

- (void)createPosterImgView {
    
    float y = _iconView.bottomY + adaptToWidth(7.5);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.width, self.height - y)];
    imageV.clipsToBounds = YES;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:imageV];
    _posterImgView = imageV;
}

- (void)createStatusLabel {
    
    YYLabel *label = [[YYLabel alloc] init];
    label.text = @"直播中";            // 未开播
    label.font = [WVRAppModel fontFitForSize:13];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = k_Color1;
    label.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = [WVRComputeTool sizeOfString:label.text Size:CGSizeMake(800, 800) Font:label.font];
    size = CGSizeMake(size.width + adaptToWidth(12), size.height + adaptToWidth(8));
    label.size = size;
    label.layer.cornerRadius = adaptToWidth(3);
    label.layer.masksToBounds = YES;
    
    label.y = _gap;
    label.bottomX = self.width - _gap;
    
    [_posterImgView addSubview:label];
    _statusLabel = label;
}

#pragma mark - data

- (void)fillInfo:(WVRShowFieldRoomData *)info {
    
    self.titleLabel.text = info.title;
    self.introLabel.text = info.intro;
    
    [self.posterImgView wvr_setImageWithURL:[NSURL URLWithUTF8String:info.image] placeholderImage:HOLDER_IMAGE];
    [self.iconView wvr_setImageWithURL:[NSURL URLWithUTF8String:info.avatar] placeholderImage:HOLDER_IMAGE];
    
    if (info.status == WVRLiveStatusPlaying) {
        
        NSString *number = info.livenum;
        
        NSString *str = [NSString stringWithFormat:@"%@人在观看", [WVRComputeTool numberToString:number.longLongValue]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        UIFont *boldFont = [WVRAppModel boldFontFitForSize:15];
        [att addAttributes:@{ NSFontAttributeName: boldFont, NSForegroundColorAttributeName : k_Color14 } range:NSMakeRange(0, number.length)];

        _viewCountLabel.attributedText = att;
        [_viewCountLabel sizeToFit];
        _viewCountLabel.centerY = _iconView.centerY;
        _viewCountLabel.bottomX = self.width - _gap;
        
        _viewCountLabel.hidden = NO;
        _statusLabel.text = @"直播中";
        _statusLabel.backgroundColor = k_Color18;
        self.introLabel.width = self.width-self.introLabel.x-_viewCountLabel.width-fitToWidth(45);
    } else {
        _viewCountLabel.hidden = YES;
        
        _statusLabel.text = @"未开播";
        _statusLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
}

@end
