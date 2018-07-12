//
//  WVRThirdPartyLoginView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRThirdPartyLoginView.h"


@interface WVRThirdPartyLoginView()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UILabel *tintLabel;
@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIImageView *QQImageView;
@property (nonatomic, strong) UIImageView *weixinImageView;
@property (nonatomic, strong) UIImageView *sinaWeiboImageView;

@property (nonatomic, strong) UILabel *bottomTintLabel;

@end

@implementation WVRThirdPartyLoginView

- (id)init
{
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)dealloc
{
}

- (void)configSelf
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, fitToWidth(126));
}

- (void)allocSubviews
{
    _leftLineView = [[UIView alloc] init];
    _tintLabel = [[UILabel alloc] init];
    _rightLineView = [[UIView alloc] init];
    
    _QQImageView = [[UIImageView alloc] init];
    _QQImageView.contentMode = UIViewContentModeScaleAspectFit;
    _weixinImageView = [[UIImageView alloc] init];
    _weixinImageView.contentMode = UIViewContentModeScaleAspectFit;
    _sinaWeiboImageView = [[UIImageView alloc] init];
    _sinaWeiboImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bottomTintLabel = [[UILabel alloc] init];
}

- (void)configSubviews
{
    _leftLineView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
    _rightLineView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
    
    _tintLabel.text = @"使用社交平台登录/注册";
    _tintLabel.font = kFontFitForSize(13);
    _tintLabel.textColor = [UIColor colorWithHex:0xc8c8c8];
    _tintLabel.textAlignment = NSTextAlignmentCenter;
    _tintLabel.backgroundColor = [UIColor whiteColor];
    _QQImageView.userInteractionEnabled = YES;
    _QQImageView.image = [UIImage imageNamed:@"thirdParty_qq"];
    [_QQImageView addGestureRecognizer:[self tapGesture]];
    _QQImageView.tag = QQ_btn_tag;
    
    _weixinImageView.userInteractionEnabled = YES;
    _weixinImageView.image = [UIImage imageNamed:@"thirdParty_wechat"];
    [_weixinImageView addGestureRecognizer:[self tapGesture]];
    _weixinImageView.tag = WX_btn_tag;
    
    _sinaWeiboImageView.userInteractionEnabled = YES;
    _sinaWeiboImageView.image = [UIImage imageNamed:@"thirdParty_sina"];
    [_sinaWeiboImageView addGestureRecognizer:[self tapGesture]];
    _sinaWeiboImageView.tag = WB_btn_tag;
    
    _bottomTintLabel.text = @"注册代表您同意微鲸VR用户协议";
    _bottomTintLabel.font = kFontFitForSize(21/2);
    _bottomTintLabel.textColor = [UIColor colorWithHex:0xc8c8c8];
    [[RACObserve([WVRUserModel sharedInstance], QQisBinded) skip:1] subscribeNext:^(id  _Nullable x) {
            NSString *currentQQImage = [WVRUserModel sharedInstance].QQisBinded? @"QQ_selected":@"thirdParty_qq";
            _QQImageView.image = [UIImage imageNamed:currentQQImage];
    }];
    [[RACObserve([WVRUserModel sharedInstance], WBisBinded) skip:1] subscribeNext:^(id  _Nullable x) {
        NSString *currentWBImage = [WVRUserModel sharedInstance].WBisBinded? @"sina_selected":@"thirdParty_sina";
        _sinaWeiboImageView.image = [UIImage imageNamed:currentWBImage];
    }];
    [[RACObserve([WVRUserModel sharedInstance], WXisBinded) skip:1] subscribeNext:^(id  _Nullable x) {
        NSString *currentWXImage = [WVRUserModel sharedInstance].WXisBinded? @"wechat_secleted":@"thirdParty_wechat";
        _weixinImageView.image = [UIImage imageNamed:currentWXImage];
    }];

    [self addSubview:_leftLineView];
    [self addSubview:_tintLabel];
//    [self addSubview:_rightLineView];
    
    [self addSubview:_QQImageView];
    [self addSubview:_weixinImageView];
    [self addSubview:_sinaWeiboImageView];
    
    [self addSubview:_bottomTintLabel];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    CGSize size = [self labelTextSize:_tintLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width+40 height:size.height toTop:fitToWidth(10)];
    _tintLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(SCREEN_WIDTH-50) height:fitToWidth(0.5) toTop:_tintLabel.top + (_tintLabel.height-0.5)/2];
    _leftLineView.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(147/2) height:(0.5) toLeft:_tintLabel.right + (10) toTop:_tintLabel.top + (_tintLabel.height-0.5)/2];
    _rightLineView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(45) height:fitToWidth(45) toTop:_tintLabel.bottom + fitToWidth(18)];
    _weixinImageView.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(45) height:fitToWidth(45) toRight:fitToWidth(35) + SCREEN_WIDTH - _weixinImageView.left toTop:_tintLabel.bottom + fitToWidth(18)];
    _QQImageView.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(45) height:fitToWidth(45) toLeft:_weixinImageView.right + fitToWidth(35) toTop:_tintLabel.bottom + fitToWidth(18)];
    _sinaWeiboImageView.frame = tmpRect;
    
    size = [self labelTextSize:_bottomTintLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toTop:_sinaWeiboImageView.bottom + fitToWidth(15)];
    _bottomTintLabel.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubvies];
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (void)setTintText:(NSString*) text
{
    _tintLabel.text = text;
}

- (void)setBottomTintLabelHidden
{
    _bottomTintLabel.hidden = YES;
}

- (void)updateStatusOfQQIcon:(BOOL) QQisBinded WBIcon:(BOOL) WBisBinded WXIcon:(BOOL) WXisBinded
{
    NSString *currentQQImage = QQisBinded? @"QQ_selected":@"thirdParty_qq";
    NSString *currentWBImage = WBisBinded? @"sina_selected":@"thirdParty_sina";
    NSString *currentWXImage = WXisBinded? @"wechat_secleted":@"thirdParty_wechat";
    
    _QQImageView.image = [UIImage imageNamed:currentQQImage];
    _sinaWeiboImageView.image = [UIImage imageNamed:currentWBImage];
    _weixinImageView.image = [UIImage imageNamed:currentWXImage];
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    UIView *tmpView = gesture.view;
    
    if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:tmpView.tag];
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

@end
