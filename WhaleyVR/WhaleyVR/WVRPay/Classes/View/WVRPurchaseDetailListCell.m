//
//  WVRPurchaseDetailListCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPurchaseDetailListCell.h"
#import "SQDateTool.h"

@interface WVRPurchaseDetailListCell () {
    
    float _space;
}

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *platformLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *dateLabel;

@end


@implementation WVRPurchaseDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _space = adaptToWidth(10);
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self nameLabel];
    [self platformLabel];
    [self priceLabel];
    [self dateLabel];
}

#pragma mark - getter

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontFitForSize(16);
        label.textColor = k_Color3;
        label.text = @"观看券";
        [label sizeToFit];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
//        label.width = SCREEN_WIDTH - adaptToWidth(90);
        
        [self addSubview:label];
        _nameLabel = label;
        
        float y = adaptToWidth(19);
        float width = SCREEN_WIDTH - 3 * _space - adaptToWidth(50);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(_space);
            make.top.equalTo(self).offset(y);
            make.height.mas_equalTo(label.height);
            make.width.mas_equalTo(width);
        }];
    }
    
    return _nameLabel;
}

- (UILabel *)platformLabel {
    
    if (!_platformLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontFitForSize(13);
        label.textColor = k_Color8;
        label.text = @"支付";
        [label sizeToFit];
        label.width = SCREEN_WIDTH - adaptToWidth(150);
        
        [self addSubview:label];
        _platformLabel = label;
        
        float y = adaptToWidth(14);
        float width = SCREEN_WIDTH * 0.5f;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(y);
            make.height.mas_equalTo(label.height);
            make.width.mas_lessThanOrEqualTo(width);
        }];
    }
    
    return _platformLabel;
}

- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontFitForSize(16);
        label.textColor = k_Color3;
        label.text = @"￥10000";
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
        
        [self addSubview:label];
        _priceLabel = label;
        
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2.f - _space;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(0 - _space);
            make.top.equalTo(_nameLabel);
            make.height.mas_equalTo(label.height);
            make.width.mas_lessThanOrEqualTo(width);
        }];
    }
    
    return _priceLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontFitForSize(13);
        label.textColor = k_Color8;
        label.text = @"2017";
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
        
        [self addSubview:label];
        _dateLabel = label;
        
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2.f - _space;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_priceLabel);
            make.centerY.equalTo(_platformLabel);
            make.height.mas_equalTo(label.height);
            make.width.mas_lessThanOrEqualTo(width);
        }];
    }
    
    return _dateLabel;
}

#pragma mark - setter

#define kCurrencyWhaleyCoin @"JINGBI"

- (void)setDataModel:(WVRUserTicketItemModel *)dataModel {
    _dataModel = dataModel;
    
    _nameLabel.text = dataModel.merchandiseName;
    
    if ([_dataModel.currency isEqualToString:kCurrencyWhaleyCoin]) {
        
        _priceLabel.text = [dataModel.amount stringByAppendingString:@" 鲸币"];
    } else {
        
        NSString *price = [WVRComputeTool numToPriceNumber:dataModel.amount.longLongValue];
        _priceLabel.text = [@"￥" stringByAppendingString:price];
    }
    
    _platformLabel.text = [self platformToString];
    
    _dateLabel.text = [SQDateTool year_month_day_hour_minute:_dataModel.updateTime];
    
    if (dataModel.nameHeight > 0) {
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(dataModel.nameHeight));
        }];
    }
}

// weixin：微信支付；alipay：支付宝支付；appStore：内购支付；whaleyCurrency：鲸币支付
- (NSString *)platformToString {
    
    if ([_dataModel.currency isEqualToString:kCurrencyWhaleyCoin]) {
        return @"鲸币支付";
    }
    NSString *platform = _dataModel.platform;
    if ([platform isEqualToString:@"weixin"]) {
        return @"微信支付";
    } else if ([platform isEqualToString:@"alipay"]) {
        return @"支付宝支付";
    } else if ([platform isEqualToString:@"appStore"]) {
        return @"内购支付";
    }
    
    DDLogError(@"未约定的支付平台： %@", platform);
    return @"";
}

@end
