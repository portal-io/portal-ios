//
//  WVROrderSWCurrencyHView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVROrderSWCurrencyHView.h"
#import "SQDateTool.h"

@interface WVROrderSWCurrencyHView()

@property (nonatomic, weak) UILabel * gRealTimeTag;

@property (nonatomic, weak) UILabel * gOriginPriceL;

@property (nonatomic, weak) UILabel * gGiveWCurrencyL;

@property (nonatomic, weak) UILabel * gOrderDateL;

@property (nonatomic, strong) WVRPayModel * gPayModel;

@end


@implementation WVROrderSWCurrencyHView

// 重写该方法，防止别人误调用
- (instancetype)initWithFrame:(CGRect)frame payModel:(WVRPayModel *)payModel type:(OrderAlertType)type canPayWithJingbi:(BOOL)canPayWithJingbi {
    
    return [self initWithFrame:frame payModel:payModel type:type];
}

- (instancetype)initWithFrame:(CGRect)frame payModel:(WVRPayModel *)payModel type:(OrderAlertType)type {
    self = [super initWithFrame:frame payModel:payModel type:type canPayWithJingbi:NO];
    if (self) {
        self.gPayModel = payModel;
        [self loadWCurrencyView:payModel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.gPayModel.giveWCurrency > 0) {
        self.statusLabel.y = self.gGiveWCurrencyL.bottomY+5.f;
        self.statusLabel.height = 16.f;
        self.gOriginPriceL.centerY = self.gGiveWCurrencyL.centerY;
    } else {
        self.gOriginPriceL.centerY = self.statusLabel.centerY;
    }
}

- (void)loadWCurrencyView:(WVRPayModel *)payModel
{
    if (payModel.payComeFromType == WVRPayComeFromTypeWCurrency) {
        if (payModel.prePrice > 0) {
            [self gRealTimeTag];
            self.gOriginPriceL.text = [NSString stringWithFormat:@"¥%0.2f", (float)payModel.originPrice/100.0];
            CGSize size = [WVRComputeTool sizeOfString:self.gOriginPriceL.text Size:CGSizeMake(800, self.gOriginPriceL.height) Font:self.gOriginPriceL.font];
            self.gOriginPriceL.width = size.width;
            self.gOriginPriceL.x = self.width - self.gOriginPriceL.width - self.statusLabel.x*2;
            self.gOriginPriceL.centerY = self.statusLabel.centerY;
            self.gOriginPriceL.hidden = NO;
        } else {
            self.gOriginPriceL.text = @"";
            self.gOriginPriceL.hidden = YES;
        }
        if (payModel.giveWCurrency > 0 ) {
            self.gGiveWCurrencyL.text = [NSString stringWithFormat:@"(赠送%d鲸币)",(int)payModel.giveWCurrency];
            self.statusLabel.y = self.gGiveWCurrencyL.bottomY+5.f;
            self.statusLabel.height = 16.f;
            self.gOriginPriceL.centerY = self.gGiveWCurrencyL.centerY;
            self.height = self.statusLabel.bottomY+adaptToWidth(42.f)+8.f;
        }
        float remindHeight = adaptToWidth(42);
        float tagY = self.height - remindHeight;
        self.gOrderDateL.frame = CGRectMake(self.statusLabel.x, tagY, self.width-self.statusLabel.x*2, remindHeight);
        
        [self installCircularBeadAndImaginaryLine:tagY];
    }
}

-(UILabel *)gRealTimeTag
{
    if (!_gRealTimeTag) {
        UILabel * cur = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsLabel.nameLabel.bottomX+10, 0, 43.f, 11.f)];
        cur.centerY = self.goodsLabel.nameLabel.centerY;
        cur.text = @"限时特惠";
        cur.textColor = [UIColor whiteColor];
        cur.layer.masksToBounds = YES;
        cur.layer.cornerRadius = 2.f;
        cur.backgroundColor = [UIColor colorWithHex:0xFF3E3E alpha:0.7];
        cur.font = [UIFont systemFontOfSize:9.0f];
        [self.goodsLabel addSubview:cur];
       
        _gRealTimeTag = cur;
    }
    return _gRealTimeTag;
}

-(UILabel *)gGiveWCurrencyL
{
    if (!_gGiveWCurrencyL) {
        UILabel * cur = [[UILabel alloc] initWithFrame:self.statusLabel.frame];
        cur.y = self.goodsLabel.bottomY+8.f;
        cur.height = 16.f;
        cur.width = self.width/2;
        cur.font = [UIFont systemFontOfSize:13.f];
        cur.textColor = k_Color20;
        _gGiveWCurrencyL = cur;
        [self addSubview:cur];
    }
    return _gGiveWCurrencyL;
}

-(UILabel *)gOriginPriceL
{
    if (!_gOriginPriceL) {
        UILabel * cur = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/2-self.statusLabel.x, 16.f)];
        cur.font = [UIFont systemFontOfSize:13.f];
        cur.textColor = k_Color20;
        [self addSubview:cur];
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = k_Color20;
        [cur addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cur);
            make.right.equalTo(cur);
            make.centerY.equalTo(cur);
            make.height.mas_equalTo(1.f);
        }];
        _gOriginPriceL = cur;
    }
    return _gOriginPriceL;
}

- (UILabel *)gOrderDateL
{
    if (!_gOrderDateL) {
        UILabel * cur = [[UILabel alloc] initWithFrame:CGRectZero];
        cur.font = [UIFont systemFontOfSize:13.f];
        cur.textColor = k_Color8;
        NSString * str = [NSString stringWithFormat:@"订单日期：%@", [SQDateTool getCurday_month_yearWithformatStr:@"YYYY年MM月dd号"]];
        cur.text = str;
        [self addSubview:cur];
        _gOrderDateL = cur;
    }
    return _gOrderDateL;
}

@end
