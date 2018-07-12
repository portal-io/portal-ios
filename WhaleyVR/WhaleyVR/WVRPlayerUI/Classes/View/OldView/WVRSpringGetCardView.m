//
//  WVRSpringGetCardView.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 获得福卡 弹出框

#import "WVRSpringGetCardView.h"
#import "YYText.h"
#import "WVRSpring2018Manager.h"

@interface WVRSpringGetCardView ()

@property (nonatomic, weak) UIImageView *mainView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *myCardBtn;
/// 抽奖次数完了只后提醒
@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) YYLabel *introLabel;
@property (nonatomic, weak) UIButton *continueBtn;
@property (nonatomic, weak) UILabel *leftCountLabel;
@property (nonatomic, weak) UIImageView *wordLightView;
@property (nonatomic, weak) UIView *wordBGView;
@property (nonatomic, weak) UILabel *wordLabel;

@end


@implementation WVRSpringGetCardView

- (instancetype)initWithModel:(WVRSpringCardModel *)dataModel {
    self = [super init];
    if (self) {
        _dataModel = dataModel;
        
        [self configSelf];
        [self configSubViews];
        
        [self installRAC];
    }
    return self;
}

- (void)dealloc {
    
    DDLogInfo(@"WVRSpringGetCardView dealloc");
}

- (void)configSelf {
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)configSubViews {
    
    [self mainView];
    [self titleLabel];
    
    [WVRSpring2018Manager shareInstance].leftCount -= 1;
    if ([WVRSpring2018Manager shareInstance].leftCount <= 0) {
        
        [self remindLabel];
    } else {
        
        [self myCardBtn];
    }
    [self closeBtn];
    [self introLabel];
    [self continueBtn];
    [self leftCountLabel];
    [self wordLightView];
    [self wordBGView];
    [self wordLabel];
}

- (void)installRAC {
    UIViewController *vc = [UIViewController getCurrentVC];
    
    kWeakSelf(self);
    [[vc rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
        if (weakself.superview) {
            [weakself removeFromSuperview];
        }
    }];
    
    [WVRSpring2018Manager checkForSpringLeftCount];
}

// MARK: - getter

- (UIImageView *)mainView {
    if (!_mainView) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spring_card_bg"]];
        imgV.userInteractionEnabled = YES;
        
        [self addSubview:imgV];
        _mainView = imgV;
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imgV.superview);
            make.height.mas_equalTo(fitToWidth(315));
            make.width.mas_equalTo(fitToWidth(265.5f));
        }];
    }
    return _mainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"获得福卡";
        label.font = [UIFont fontWithName:@"FZYiHei-M20S" size:fitToWidth(34)];
        label.textColor = k_Color_hex(0xffd699);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.mainView addSubview:label];
        _titleLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.superview).offset(fitToWidth(26));
            make.centerX.equalTo(label.superview);
        }];
    }
    
    return _titleLabel;
}

- (UIButton *)myCardBtn {
    if (!_myCardBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = _dataModel.finished;
        btn.titleLabel.font = kFontFitForSize(12.5);
        [btn setTitleColor:k_Color_hex(0xffd599) forState:UIControlStateNormal];
        
        [btn setTitle:@"查看我的福卡 >" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(myCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:btn];
        _myCardBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fitToWidth(18));
            make.width.mas_equalTo(fitToWidth(90));
            make.top.equalTo(btn.superview).offset(fitToWidth(75));
            make.right.equalTo(btn.superview).offset(fitToWidth(-15));
        }];
    }
    return _myCardBtn;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = kFontFitForSize(12);
        [label setTextColor:k_Color_hex(0xffd599)];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label setText:@"今天的福卡已经领完、分享后再领3张"];
        [self.mainView addSubview:label];
        _remindLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(fitToWidth(18));
//            make.width.mas_equalTo(fitToWidth(180));
            make.top.equalTo(label.superview).offset(fitToWidth(75));
            make.centerX.equalTo(label.superview);
        }];
    }
    return _remindLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_spring_card_close"] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        float width = fitToWidth(18.5);
        
        [btn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _closeBtn = btn;
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.mainView).offset(fitToWidth(5));
            make.top.equalTo(weakself.mainView).offset(fitToWidth(6));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
    }
    return _closeBtn;
}

- (YYLabel *)introLabel {
    if (!_introLabel) {
        YYLabel *label = [[YYLabel alloc] init];
        
        NSAttributedString *attStr = nil;
        if (_dataModel.finished) {
            
            UIColor *color = k_Color_hex(0xd60c0c);
            NSString *str = [NSString stringWithFormat:@"你已集齐“%@”%@张福卡 去查看>", _dataModel.relCardsName, [_dataModel relCardsCntString]];
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFontFitForSize(11), NSForegroundColorAttributeName : color }];
            
            kWeakSelf(self);
            NSRange range = NSMakeRange(str.length - 4, 4);
            [text yy_setTextHighlightRange:range
                                     color:color
                           backgroundColor:[UIColor clearColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                     [weakself myCardBtnClicked:nil];
                                 }];
            attStr = text;
            
        } else {
            NSString *str = [NSString stringWithFormat:@"集齐“%@”%@张福卡后%@", _dataModel.relCardsName, [_dataModel relCardsCntString], [_dataModel relCardGrpTypeString]];
            attStr = [[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName: kFontFitForSize(11), NSForegroundColorAttributeName: k_Color_hex(0x666666) }];
        }
        
        label.attributedText = attStr;
        
        [self.mainView addSubview:label];
        _introLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label.superview);
            make.centerY.equalTo(label.superview).offset(fitToWidth(46));
        }];
    }
    return _introLabel;
}

- (UIButton *)continueBtn {
    if (!_continueBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.backgroundColor = k_Color_hex(0xffd699);
        [btn setTitleColor:k_Color_hex(0xf34a3e) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"FZYiHei-M20S" size:fitToWidth(19)];
        
        if ([[WVRSpring2018Manager shareInstance] leftCount] > 0) {
            [btn setTitle:@"继续收集" forState:UIControlStateNormal];
            btn.tag = 1;
        } else {
            [btn setTitle:@"查看我的福卡" forState:UIControlStateNormal];
        }
        
        float height = fitToWidth(39);
        btn.layer.cornerRadius = height * 0.5f;
        btn.layer.masksToBounds = YES;
        
        [btn addTarget:self action:@selector(continueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:btn];
        _continueBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.superview);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(fitToWidth(191));
            make.bottom.equalTo(btn.superview).offset(fitToWidth(-32.5f));
        }];
    }
    return _continueBtn;
}

- (UILabel *)leftCountLabel {
    if (!_leftCountLabel) {
        
        NSString *str = nil;
        int count = [WVRSpring2018Manager shareInstance].leftCount;
        if (count > 0) {
            str = [NSString stringWithFormat:@"今日还有 %d 张福卡可领取", count];
        } else {
            str = @"分享我的成果";
        }
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.textColor = k_Color_hex(0xffd599);
        label.font = kFontFitForSize(11);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.mainView addSubview:label];
        _leftCountLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label.superview);
            make.bottom.equalTo(label.superview).offset(fitToWidth(-11.5f));
        }];
    }
    return _leftCountLabel;
}

- (UIImageView *)wordLightView {
    if (!_wordLightView) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spring_card_light"]];
        
        [self.mainView addSubview:imgV];
        _wordLightView = imgV;
        
        NSNumber *width = @(fitToWidth(125));
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgV.superview);
            make.top.equalTo(imgV.superview).offset(fitToWidth(85));
            make.width.equalTo(width);
            make.height.equalTo(width);
        }];
    }
    return _wordLightView;
}

- (UIView *)wordBGView {
    if (!_wordBGView) {
        UIView *view = [[UIView alloc] init];
        float width = fitToWidth(66);
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, width, width);
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[k_Color_hex(0xe42414) CGColor],
                                (id)[k_Color_hex(0xff5344) CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        
        [view.layer insertSublayer:gradientLayer atIndex:0];
        
        view.layer.cornerRadius = fitToWidth(3.5);
        view.layer.masksToBounds = YES;
        
        CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI / 180.f * 4);
        view.transform = transform;
        
        [self.mainView addSubview:view];
        _wordBGView = view;
        
        kWeakSelf(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakself.wordLightView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spring_card_wordbg_red"]];
        [view addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            float offset = fitToWidth(-10);
            make.center.equalTo(imgV.superview);
            make.width.equalTo(imgV.superview).offset(offset);
            make.height.equalTo(imgV.superview).offset(offset);
        }];
    }
    return _wordBGView;
}

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _dataModel.relCardName;
        label.font = [UIFont fontWithName:@"FZYiHei-M20S" size:fitToWidth(46.5)];
        label.textColor = k_Color_hex(0xffd599);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.wordBGView addSubview:label];
        _wordLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(label.superview);
        }];
    }
    return _wordLabel;
}

// MARK: - action

- (void)continueBtnClicked:(UIButton *)sender {
    
    [self removeFromSuperview];
    
    // =1 表示还可以继续抽卡片
    if (sender.tag == 1) {
        
        if ([self.delegate respondsToSelector:@selector(cardClosed)]) {
            [self.delegate performSelector:@selector(cardClosed)];
        }
    } else {
        
        if ([self.delegate respondsToSelector:@selector(gotoMyCardVC)]) {
            [self.delegate performSelector:@selector(gotoMyCardVC)];
        }
    }
}

- (void)myCardBtnClicked:(UIButton *)sender {
    
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(gotoMyCardVC)]) {
        [self.delegate performSelector:@selector(gotoMyCardVC)];
    }
}

- (void)closeBtnClicked:(UIButton *)sender {
    
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(cardClosed)]) {
        [self.delegate performSelector:@selector(cardClosed)];
    }
}

@end
