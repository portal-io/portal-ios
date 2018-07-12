//
//  WVRMineSuspendView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineSuspendView.h"


@implementation WVRMineSuspendView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - adaptToWidth(20), adaptToWidth(88))];
    if (self) {
        
        [self configSelf];
        [self createSubviews];
    }
    return self;
}

- (void)configSelf {
    
    UIView *view = [[UIImageView alloc] initWithFrame:self.bounds];
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = adaptToWidth(5);
    view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:view];
    
    CALayer *subLayer = [CALayer layer];
    
    subLayer.frame = self.bounds;
    subLayer.masksToBounds = NO;
    subLayer.cornerRadius = adaptToWidth(5);
    subLayer.backgroundColor = [UIColor grayColor].CGColor;
    subLayer.shadowColor = [UIColor grayColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(5, 5);
    subLayer.shadowOpacity = 0.15;
    subLayer.shadowRadius = 5;
    
    [self.layer insertSublayer:subLayer below:view.layer];
}

- (void)createSubviews {
    
    NSArray *titleArr = @[ @"鲸币", @"兑换码/券", @"我的奖品" ];
    NSArray *imgArr = @[ @"mine_icon_gold", @"mine_icon_ticket", @"mine_icon_mygift" ];
    
    int count = 0;
    for (NSString *title in titleArr) {
        
        if (count >= imgArr.count) { break; }
        NSString *img = imgArr[count];
        
        UIButton *btn = [[WVRMineSuspendButton alloc] initWithImageName:img title:title];
        btn.tag = count;
        
        float offset = 0;
        if (count == 0) {
            offset = 0 - fitToWidth(20);
        } else if (count == 2) {
            offset = fitToWidth(20);
        }
        
        btn.centerX = self.width / 4.f * (count + 1) + offset;
        btn.centerY = self.height * 0.5;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        count ++;
    }
}

- (void)buttonClick:(UIButton *)btn {
    
    if (self.btnClickBlock) {
        self.btnClickBlock(btn.tag);
    }
}

@end


@implementation WVRMineSuspendButton

- (instancetype)initWithImageName:(NSString *)imgName title:(NSString *)title {
    
    self = [super initWithFrame:CGRectMake(0, 0, adaptToWidth(90), adaptToWidth(70))];
    if (self) {
        
        [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:k_Color4 forState:UIControlStateNormal];
        self.titleLabel.font = kFontFitForSize(15);
        
        [self verticalImageAndTitle:adaptToWidth(9)];
    }
    return self;
}

- (void)verticalImageAndTitle:(CGFloat)spacing {
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: self.titleLabel.font }];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0, 0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
