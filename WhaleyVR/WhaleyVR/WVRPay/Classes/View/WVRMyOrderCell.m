//
//  WVRMyOrderCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的购买cell

#import "WVRMyOrderCell.h"

@interface WVRMyOrderCell () {
    
    float _gap;
}

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *statusLabel;

// 合集
@property (nonatomic, weak) UILabel *badgeLabel;

// 直播
@property (nonatomic, weak) UILabel *liveStatusLabel;

@end


@implementation WVRMyOrderCell

// height 132   width:screenWidth
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildData];
        [self configSelf];
        [self configSubviews];
    }
    return self;
}

- (void)buildData {
    
    _gap = adaptToWidth(10.5);
}

- (void)configSelf {
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)configSubviews {
    
    [self createIconView];
    [self createTitleLabel];
    [self createTimeLabel];
    [self createPriceLabel];
    [self createBadgeLabel];
    [self createStatusLabel];
    [self createLiveStatusLabel];
}

#pragma mark - subview

- (void)createIconView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(_gap, _gap, adaptToWidth(125), adaptToWidth(71))];
    imgV.layer.masksToBounds = YES;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:imgV];
    _iconView = imgV;
}

- (void)createTitleLabel {
    
    float x = _iconView.bottomX;
    float y = _iconView.y + adaptToWidth(3);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + _gap, y, 100, 30)];
    label.text = @"标题";
    label.textColor = k_Color3;
    label.font = kFontFitForSize(12.5);
    [label sizeToFit];
    label.width = self.width - x - 2 * _gap;
    
    [self addSubview:label];
    _titleLabel = label;
}

- (void)createTimeLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:_titleLabel.bounds];
    label.textColor = k_Color8;
    label.font = _titleLabel.font;
    
    label.centerY = _iconView.centerY;
    label.x = _titleLabel.x;
    
    [self addSubview:label];
    _timeLabel = label;
}

- (void)createPriceLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:_titleLabel.bounds];
    label.textColor = _timeLabel.textColor;
    label.font = _titleLabel.font;
    
    label.bottomY = _iconView.bottomY - adaptToWidth(5);
    label.x = _titleLabel.x;
    label.width = label.width * 0.55;
    
    [self addSubview:label];
    _priceLabel = label;
}

- (void)createStatusLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = _titleLabel.font;
    
    label.text = @"待支付";
    [label sizeToFit];
    
    label.bottomX = self.width - _gap;
    label.bottomY = _priceLabel.bottomY;
    
    [self addSubview:label];
    _statusLabel = label;
}

- (void)createBadgeLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    label.font = kFontFitForSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [_iconView addSubview:label];
    _badgeLabel = label;
}

- (void)createLiveStatusLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color3;
    label.font = kFontFitForSize(11.5);
    label.text = @"直播未开始";
    label.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = [WVRComputeTool sizeOfString:label.text Size:CGSizeMake(800, 800) Font:label.font];
    
    float width = size.width + adaptToWidth(14);
    float height = size.height + adaptToWidth(6);
    
    label.size = CGSizeMake(width, height);
    label.center = CGPointMake(_iconView.width / 2.0, _iconView.height / 2.0);
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.height / 2.0;
    label.backgroundColor = [UIColor whiteColor];
    
    [_iconView addSubview:label];
    _liveStatusLabel = label;
}

#pragma mark - setter

- (void)setDataModel:(WVRMyOrderItemModel *)dataModel {
    
    _dataModel = dataModel;
    
    [self setType:[dataModel purchaseType]];
    
    if (self.type == PurchaseProgramTypeCollection) {
        [self setBadge:dataModel.merchandiseContentCount];
    }
    [self updateStatus:(dataModel.result == MyOrderStatusPaid)];
    [self.iconView wvr_setImageWithURL:[NSURL URLWithUTF8String:dataModel.merchandiseImage] placeholderImage:HOLDER_IMAGE];
    
    self.titleLabel.text = dataModel.merchandiseName;
    
    [self updateTime:dataModel.updateTime];
    if (dataModel.result == MyOrderStatusPaid) {
        [self updatePrice:dataModel.amount];
    } else {
        [self updatePrice:dataModel.merchandisePrice];
    }
    
    
    [self updateLiveStatus];
}

- (void)setType:(PurchaseProgramType)type {
    _type = type;
    
    _badgeLabel.hidden = (type != PurchaseProgramTypeCollection);
    _liveStatusLabel.hidden = (type != PurchaseProgramTypeLive);
}

- (void)setBadge:(long)badge {
    
    NSString *str = [NSString stringWithFormat:@"共%@部", [WVRComputeTool numberToString:badge]];
    CGSize size = [WVRComputeTool sizeOfString:str Size:CGSizeMake(800, 800) Font:_badgeLabel.font];
    _badgeLabel.text = str;
    
    float width = size.width + adaptToWidth(9);
    float height = size.height + adaptToWidth(6);
    
    _badgeLabel.frame = CGRectMake(_iconView.width - width, _iconView.height - height, width, height);
}

#pragma mark - func

- (void)updateStatus:(BOOL)isCharged {
    if (isCharged) {
        _statusLabel.textColor = k_Color8;
        _statusLabel.text = @"已支付";
    } else {
        _statusLabel.textColor = k_Color15;
        _statusLabel.text = @"待支付";
    }
}

- (void)updateTime:(long)time {
    
    if (time > 100000000000) {
        time = time / 1000;
    }
    
    NSString *text = @"时间：";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    text = [text stringByAppendingString:confromTimespStr];
    
    self.timeLabel.text = text;
}

- (void)updatePrice:(long)price {
    
    NSString *text = @"金额：¥";
    if (price % 10 == 0) {
        text = [NSString stringWithFormat:@"%@%.1f", text, price / 100.0];
    } else {
        text = [NSString stringWithFormat:@"%@%.2f", text, price / 100.0];
    }
    self.priceLabel.text = text;
}

- (void)updateLiveStatus {
    if (_dataModel.purchaseType == PurchaseProgramTypeLive) {
        
        if (_dataModel.liveStatus == WVRLiveStatusPlaying) {
            
            _liveStatusLabel.text = @"正在直播中";
            _liveStatusLabel.backgroundColor = Color_RGB(41, 232, 143);
            
        } else if (_dataModel.liveStatus == WVRLiveStatusNotStart) {
            
            _liveStatusLabel.text = @"直播未开始";
            _liveStatusLabel.backgroundColor = [UIColor whiteColor];
        } else {
            _liveStatusLabel.hidden = YES;
        }
    }
}

@end
