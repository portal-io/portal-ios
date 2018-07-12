//
//  WVRLiveAlertView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/1/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveAlertView.h"
#import "YYText.h"
#import "UIColor+Extend.h"
#import "UIImage+Extend.h"

@interface WVRLiveAlertView ()

@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UIImageView *backgroundView;

// title
@property (nonatomic, weak) UILabel *videoTitleLabel;
@property (nonatomic, weak) YYLabel *countLabel;
@property (nonatomic, weak) YYLabel *addressLabel;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UILabel *introLabel;

// lottery
@property (nonatomic, weak) UILabel *lotteryTitleLabel;
@property (nonatomic, weak) UILabel *lotteryNameLabel;
@property (nonatomic, weak) UIImageView *lotteryImageView;
@property (nonatomic, weak) UIButton *lotteryBtn;
@property (nonatomic, weak) UILabel *lotteryTimeLabel;

@end


@implementation WVRLiveAlertView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        float height = MAX(SCREEN_HEIGHT, SCREEN_WIDTH);
        
        self.frame = CGRectMake(0, 0, width, height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        
        self.tag = tag_TOAST_IN_WINDOWS;
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(300), height/2-fitToWidth(75))];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.clipsToBounds = YES;
        mainView.layer.cornerRadius = adaptToWidth(7);
        mainView.center = CGPointMake(width / 2.f, height/2.f - adaptToWidth(20));
        
        [self addSubview:mainView];
        _mainView = mainView;
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live_alert_bg"]];
        imgV.clipsToBounds = YES;
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        
        float scale = mainView.width / imgV.width;
        imgV.width = imgV.width * scale;
        imgV.height = imgV.height * scale;
        
        [_mainView addSubview:imgV];
        _backgroundView = imgV;
        
        
        UIViewController *vc = kRootViewController;
        [vc.view addSubview:self];
        
        kWeakSelf(self);
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.size.equalTo(weakself.superview);
        }];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title playCount:(long)playCount adress:(NSString *)address intro:(NSString *)intro {
    
    WVRLiveAlertView *view = [[WVRLiveAlertView alloc] init];
    [view createVideoTitleLabel:title];
    [view createCountLabel:playCount];
    [view createAddressLabel:address];
    [view createIntroLabel:intro];
    
    return view;
}

- (instancetype)initWithLotteryImage:(NSString *)image title:(NSString *)title lotteryTime:(int)time delegate:(id<WVRPlayerViewLiveDelegate>)delegate {
    
    WVRLiveAlertView *view = [[WVRLiveAlertView alloc] init];
    
    view.liveDelegate = delegate;
    [view createLotteryTitleLabel:image ? @"恭喜你抽中了" : @"真可惜！什么都没有!"];
    [view createLotteryNameLabel:title ?: @""];
    [view createLotteryImageView:image];
    [view createLotteryBtn:image ? @"前往领奖" : @"等会儿再来"];
    [view createLotteryTimeLabel:time];
    
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    float gap = adaptToWidth(20);
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f);
    
    _mainView.center = self.center;
    _backgroundView.center = self.center;
    
//    _mainView.bounds = CGRectMake(0, 0, self.width-fitToWidth(75), self.height/2);
    
//    _backgroundView.bounds = _mainView.bounds;
//    _videoTitleLabel.bounds = CGRectMake(0, 0, _mainView.bounds.size.width-gap*2, gap);
//    _videoTitleLabel.center = CGPointMake(_mainView.bounds.size.width/2, gap+_videoTitleLabel.bounds.size.height/2);
//    _countLabel.bounds = CGRectMake(0, 0, _mainView.bounds.size.width/2-gap*2, gap);
//    _countLabel.center = CGPointMake(_mainView.bounds.size.width/2/2, _videoTitleLabel.center.y+fitToWidth(17.f)+_countLabel.bounds.size.height/2);
//    _addressLabel.bounds = CGRectMake(0, 0, _mainView.bounds.size.width-_countLabel.center.x*2-gap, gap);
//    _addressLabel.center = CGPointMake(_mainView.bounds.size.width/2+_mainView.bounds.size.width/4, _countLabel.center.y);
//    
//    _line.bounds = CGRectMake(0, 0, _mainView.bounds.size.width-gap*2, 0.5);
//    _line.center = CGPointMake(_mainView.bounds.size.width/2, _addressLabel.center.y + _addressLabel.bounds.size.height/2+gap+0.5/2);
//    _introLabel.bounds = CGRectMake(0, 0, _mainView.bounds.size.width-gap*2, _mainView.bounds.size.height-_line.center.y+0.5/2+gap);
//    _introLabel.center = CGPointMake(_mainView.bounds.size.width/2, _line.center.y + 0.5/2 + gap + (_mainView.bounds.size.height - _line.center.y + 0.5/2 + gap)/2);
}

#pragma mark - Live UI

- (void)createVideoTitleLabel:(NSString *)title {
    
    float gap = adaptToWidth(20);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gap, gap, _mainView.width - gap * 2, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [WVRAppModel fontFitForSize:18];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.text = title;
    label.numberOfLines = 0;
    
    CGSize size = [WVRComputeTool sizeOfString:title Size:CGSizeMake(label.width - gap * 2, LONG_MAX) Font:label.font];
    label.height = size.height;
    
    [_mainView addSubview:label];
    _videoTitleLabel = label;
}

- (void)createCountLabel:(long)count {
    
    UIFont *font = [WVRAppModel fontFitForSize:12.5];
    UIImage *image = [UIImage imageNamed:@"icon_want_watch_peoples"];
    NSString *str = [NSString stringWithFormat:@"  %@人正在浏览", [WVRComputeTool numberToString:count]];
    
    YYLabel *countLabel = [[YYLabel alloc] init];
    countLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0x898989], NSFontAttributeName:font }]];
    
    countLabel.attributedText = [text copy];
    CGSize sizeOriginal = CGSizeMake(_videoTitleLabel.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    countLabel.size = layout.textBoundingSize;
    countLabel.textLayout = layout;
    countLabel.y = _videoTitleLabel.bottomY + adaptToWidth(17);
    countLabel.x = _videoTitleLabel.x;
    
    [_mainView addSubview:countLabel];
    _countLabel = countLabel;
}

- (void)createAddressLabel:(NSString *)address {
    
    // 直播地址
    YYLabel *addressLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_countLabel.bottomX + adaptToWidth(17), _countLabel.y, 200, 30)];
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    UIFont *font = [WVRAppModel fontFitForSize:12.5];
    UIImage *image = [UIImage imageNamed:@"icon_area_black"];
    NSString *str = [NSString stringWithFormat:@"  %@", address];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0x898989], NSFontAttributeName:font }]];
    
    addressLabel.attributedText = [text copy];
    
    CGSize sizeOriginal = CGSizeMake(_mainView.width - addressLabel.x - adaptToWidth(12), CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    addressLabel.size = layout.textBoundingSize;
    addressLabel.textLayout = layout;
    addressLabel.centerY = _countLabel.centerY;
    
    [_mainView addSubview:addressLabel];
    _addressLabel = addressLabel;
}

- (void)createIntroLabel:(NSString *)intro {
    
    float gap = _videoTitleLabel.x;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _countLabel.bottomY + gap, _mainView.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0x898989];
    _line = line;
    [_mainView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gap, line.bottomY + gap, _videoTitleLabel.width, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHex:0x898989];
    label.font = [WVRAppModel fontFitForSize:12.5];
    label.text = intro;
    label.numberOfLines = 0;
    
    CGSize size = [WVRComputeTool sizeOfString:intro Size:CGSizeMake(label.width - gap * 2, LONG_MAX) Font:label.font];
    label.height = MIN(MIN(SCREEN_WIDTH/2, SCREEN_HEIGHT/2),size.height);
    
//    label.height = MIN(label.height, MIN(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)-line.bottomY-gap);
    [_mainView addSubview:label];
    _introLabel = label;
    
    _mainView.height = label.bottomY + adaptToWidth(44);
    _backgroundView.bottomY = _mainView.height;
}

#pragma mark - lottery UI

- (void)createLotteryTitleLabel:(NSString *)text {
    
    float gap = adaptToWidth(30);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gap, gap, _mainView.width - gap * 2, 20)];
    
    label.font = [WVRAppModel boldFontFitForSize:18];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.text = text;
    [label sizeToFit];
    label.centerX = _mainView.width / 2.f;
    
    [_mainView addSubview:label];
    _lotteryTitleLabel = label;
}

- (void)createLotteryNameLabel:(NSString *)name {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _lotteryTitleLabel.bottomY + adaptToWidth(8), _mainView.width, 20)];
    
    label.font = [WVRAppModel fontFitForSize:14];
    label.textColor = [UIColor colorWithHex:0xFF4B4B];
    label.text = name;
    [label sizeToFit];
    label.centerX = _mainView.width / 2.f;
    
    [_mainView addSubview:label];
    _lotteryNameLabel = label;
}

- (void)createLotteryImageView:(NSString *)image {
    
    float width = adaptToWidth(166);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _lotteryNameLabel.bottomY + adaptToWidth(10), width, width)];
    imageV.centerX = _mainView.width/2.f;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.backgroundColor = [UIColor clearColor];
    
    if (image.length > 0) {
        [imageV wvr_setImageWithURL:[NSURL URLWithUTF8String:image]];
    } else {
        [imageV setImage:[UIImage imageNamed:@"player_lottery_nothing"]];
    }
    
    [_mainView addSubview:imageV];
    
    _lotteryImageView = imageV;
}

- (void)createLotteryBtn:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageWithColor:k_Color1 size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    btn.layer.cornerRadius = adaptToWidth(7);
    btn.clipsToBounds = YES;
    btn.frame = CGRectMake(0, _lotteryImageView.bottomY + adaptToWidth(10), _lotteryImageView.width, adaptToWidth(40));
    btn.centerX = _mainView.width/2.f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [WVRAppModel fontFitForSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(lotteryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:btn];
    _lotteryBtn = btn;
}

- (void)createLotteryTimeLabel:(int)time {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _lotteryBtn.bottomY + adaptToWidth(13), _mainView.width, 20)];
    
    label.font = [WVRAppModel fontFitForSize:12];
    label.textColor = [UIColor colorWithHex:0x898989];
    NSString *text = @"";
    if (time / 60 == 0) {
        text = [NSString stringWithFormat:@"下次抽奖时间在%d秒之后", time];
    } else if (time % 60 == 0) {
        text = [NSString stringWithFormat:@"下次抽奖时间在%d分钟之后", time/60];
    } else {
        text = [NSString stringWithFormat:@"下次抽奖时间在%d分%d秒之后", time/60, time % 60];
    }
    label.text = text;
    [label sizeToFit];
    label.centerX = _mainView.width / 2.f;
    
    [_mainView addSubview:label];
    _lotteryTimeLabel = label;
    
    _mainView.height = label.bottomY + adaptToWidth(40);
    _backgroundView.bottomY = _mainView.height;
}

#pragma mark - getter



#pragma mark - action

- (void)lotteryBtnClick:(UIButton *)sender {
    
    if (self.lotteryNameLabel.text.length > 0) {
        if ([self.liveDelegate respondsToSelector:@selector(actionGoGiftPage)]) {
            [self.liveDelegate actionGoGiftPage];
        }
    }
    [self removeFromSuperview];
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    if (touch.view == self) {
        [self removeFromSuperview];
    }
}

#pragma mark - external

// 点击title，展示基本信息
//+ (instancetype)showWithTitle:(NSString *)title playCount:(long)playCount adress:(NSString *)address intro:(NSString *)intro {
//    
//    WVRLiveAlertView *view = [[WVRLiveAlertView alloc] initWithTitle:title playCount:playCount adress:address intro:intro];
//    
//    return view;
//}

// 中奖
+ (instancetype)showWithImage:(NSString *)image title:(NSString *)title lotteryTime:(int)time delegate:(id<WVRPlayerViewLiveDelegate>)delegate {
    
    WVRLiveAlertView *view = [[WVRLiveAlertView alloc] initWithLotteryImage:image title:title lotteryTime:time delegate:delegate];
    
    return view;
}

// 未中奖
+ (instancetype)showWithLotteryTime:(int)time {
    
    WVRLiveAlertView *view = [[WVRLiveAlertView alloc] initWithLotteryImage:nil title:nil lotteryTime:time delegate:nil];
    
    return view;
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}

@end
