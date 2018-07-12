//
//  WVRExchangeSuccessView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRExchangeSuccessView.h"
#import "SQDateTool.h"
#import <WVRAppContextHeader.h>
#import <UIView+Extend.h>
#import "WVRMediator+Launcher.h"

@interface WVRExchangeSuccessView () {
    
    float _space;
}

@property (nonatomic, weak) UIImageView *successIcon;
@property (nonatomic, weak) UILabel *successLabel;

@property (nonatomic, weak) WVRExchangeSuccessCenterView  *mainView;

@end


@implementation WVRExchangeSuccessView

- (instancetype)initWithDataModel:(WVRMyTicketItemModel *)dataModel {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _dataModel = dataModel;
        _space = adaptToWidth(15);
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
    
    [self createMainView];
    
    [self successLabel];
    [self successIcon];
}

- (void)createMainView {
    
    WVRExchangeSuccessCenterView *view = [[WVRExchangeSuccessCenterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _dataModel.cellHeight)];
    view.dataModel = self.dataModel;
    view.centerY = self.height * 0.5;
    
    [self addSubview:view];
    _mainView = view;
}

- (UIImageView *)successIcon {
    
    if (!_successIcon) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pay_successed"]];
        
        imgV.centerX = self.successLabel.centerX;
        imgV.bottomY = self.successLabel.y - adaptToWidth(12);
        
        [self addSubview:imgV];
        _successIcon = imgV;
    }
    return _successIcon;
}

- (UILabel *)successLabel {
    
    if (!_successLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"兑换成功";
        label.font = kFontFitForSize(18);
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        
        label.centerX = self.width * 0.5;
        label.bottomY = self.mainView.y - adaptToWidth(40);
        
        [self addSubview:label];
        _successLabel = label;
    }
    return _successLabel;
}

#pragma mark - action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.mainView];
    
    BOOL isX = point.x > _space && point.x < (self.width - 2 * _space);
    BOOL isY = (point.y > 0 && point.y < self.mainView.height);
    if (isX && isY) {
        
        [self detailButtonClick:nil];
    } else {
        
        [self dissmissWithAnimate];
    }
}

- (void)detailButtonClick:(UIButton *)sender {
    
    if (self.lookupDetailBlock) {
        self.lookupDetailBlock();
        self.lookupDetailBlock = nil;
    }
    
    [self removeFromSuperview];
}

#define Animat_Time 0.26

- (void)showWithAnimate {
    
    UITabBarController *tab = [[WVRMediator sharedInstance] WVRMediator_TabbarController];

    UIView *tmpView = [tab.view.subviews lastObject];
    if ([tmpView isKindOfClass:NSClassFromString(@"WVRRedeemExchangeView")]) {
        
        [tab.view insertSubview:self belowSubview:tmpView];
    } else {
        
        [tab.view addSubview:self];
    }
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         [self successIconAnimate];
                     }];
}

- (void)dissmissWithAnimate {
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alpha = 0.05;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

- (void)successIconAnimate {
    
    [self.successIcon springAnimation];
}

@end


@interface WVRExchangeSuccessCenterView () {
    
    float _space;
    float _tagY;
    float _remindHeight;
}

@property (nonatomic, weak) UIImageView *mainView;
@property (nonatomic, weak) CALayer *lineLayer;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *codeLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UIButton *detailBtn;
@property (nonatomic, weak) UILabel *remindLabel;

@property (nonatomic, weak) CALayer *subLayer;

@end


@implementation WVRExchangeSuccessCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _space = adaptToWidth(15);
        
        [self drawUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _mainView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    _subLayer.frame = CGRectMake(_mainView.x, self.mainView.bottomY - _subLayer.frame.size.height, _subLayer.frame.size.width, _subLayer.frame.size.height);
    
    _priceLabel.bottomX = _mainView.width - _space;
}

- (void)drawUI {
    
    if (self.mainView) { return; }
    
    self.backgroundColor = [UIColor clearColor];
    
    [self createMainView];
    
    _remindHeight = adaptToWidth(42);
    _tagY = _mainView.height - _remindHeight;
    float centerX = _mainView.width * 0.5;
    float titleCenterY = adaptToWidth(31);
    
    // mainView's subview width
    float sub_width = _mainView.frame.size.width - 2 * _space;
    
    [self createNameLabelWithCenterY:titleCenterY];
    
    [self createCodeLabel];
    
    [self createPriceLabel];
    
    [self createDottedLineWithCenterX:centerX tagY:_tagY subWidth:sub_width];
    
    [self createRemindLabelWithTagY:_tagY subWidth:sub_width remindHeight:_remindHeight];
    
    [self createDetailBtn];
}

- (void)createMainView {
    
    UIImageView *view = [[UIImageView alloc] initWithImage:[self imageForView:[self viewForImage]]];
    
    [self addSubview:view];
    _mainView = view;
    
    CALayer *subLayer = [CALayer layer];
    
    float height = adaptToWidth(15);
    subLayer.frame = CGRectMake(0, 0, _mainView.width, height);
    subLayer.cornerRadius = adaptToWidth(8);
    subLayer.backgroundColor = [UIColor grayColor].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = [UIColor grayColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(10, 10);
    subLayer.shadowOpacity = 0.15;
    subLayer.shadowRadius = 10;
    
    [self.layer insertSublayer:subLayer below:_mainView.layer];
    _subLayer = subLayer;
}

- (void)createNameLabelWithCenterY:(float)titleCenterY {
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"观看券";
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = k_Color3;
    nameLabel.font = [WVRMyTicketItemModel nameLabelFont];
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [nameLabel sizeToFit];
    
    nameLabel.x = _space;
    nameLabel.width = _mainView.width - 3 * _space;
    nameLabel.centerY = titleCenterY;
    
    [_mainView addSubview:nameLabel];
    _nameLabel = nameLabel;
}

- (void)createCodeLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x, 80, 90, 40)];
    label.text = @"DDDDDD";
    label.textColor = k_Color1;
    label.font = [WVRMyTicketItemModel nameLabelFont];
    [label sizeToFit];
    
    label.width = _mainView.width - 3 * _space;
    
    [_mainView addSubview:label];
    _codeLabel = label;
}

- (void)createPriceLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color20;
    label.font = _nameLabel.font;
    label.text = @"￥10";
    [label sizeToFit];
    label.centerY = _nameLabel.centerY;
    
    [_mainView addSubview:label];
    _priceLabel = label;
}

// 虚线
- (void)createDottedLineWithCenterX:(float)centerX tagY:(float)tagY subWidth:(float)sub_width {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, sub_width, 1)];
    [shapeLayer setPosition:CGPointMake(centerX, tagY - 0.5)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[k_Color9 CGColor]];
    // 设置虚线的宽度
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 5=线的宽度 3=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, sub_width, 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [_mainView.layer addSublayer:shapeLayer];
    _lineLayer = shapeLayer;
}

- (void)createRemindLabelWithTagY:(float)tagY subWidth:(float)sub_width remindHeight:(float)remindHeight {
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, tagY, sub_width, remindHeight)];
    remindLabel.textColor = k_Color8;
    remindLabel.font = kFontFitForSize(13);
    NSString *remind = @"购买于";
    remindLabel.text = remind;
//    [remindLabel sizeToFit];
    _remindLabel.width = _mainView.width * 0.6;
    
    [_mainView addSubview:remindLabel];
    _remindLabel = remindLabel;
}

- (void)createDetailBtn {
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.bounds = CGRectMake(0, 0, adaptToWidth(45), adaptToWidth(30));
    detailBtn.centerY = _remindLabel.centerY;
    detailBtn.bottomX = _mainView.width - _space;
    detailBtn.userInteractionEnabled = NO;
    
    [detailBtn.titleLabel setFont:kFontFitForSize(13)];
    [detailBtn setTitle:@"查看>" forState:UIControlStateNormal];
    [detailBtn setTitleColor:k_Color8 forState:UIControlStateNormal];
//    [detailBtn addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:detailBtn];
    _detailBtn = detailBtn;
}

#pragma mark - setter

- (void)setDataModel:(WVRMyTicketItemModel *)dataModel {
    
    _dataModel = dataModel;
    
    _mainView.height = dataModel.cellHeight - _space;
    
    _tagY = _mainView.height - _remindHeight;
    
    [_lineLayer setPosition:CGPointMake(_mainView.width * 0.5, _tagY - 0.5)];
    
    _remindLabel.y = _tagY;
    _detailBtn.centerY = _remindLabel.centerY;
    
    _nameLabel.text = dataModel.displayName;
    _priceLabel.text = dataModel.priceStr;
    
    NSString *time = [SQDateTool year_month_day_ch:_dataModel.createTime];
    NSString *remind = [@"购买于" stringByAppendingString:time];
    _remindLabel.text = remind;
    
    float bottomY = _priceLabel.bottomY;
    _priceLabel.width = dataModel.priceLabelSize.width;
    _priceLabel.bottomX = bottomY;
    
    _nameLabel.width = dataModel.nameLabelWidth;
    _nameLabel.height = dataModel.nameLabelHeight;
    
    if ([dataModel purchaseType] == PurchaseProgramTypeLive && dataModel.liveStatus == WVRLiveStatusNotStart) {
        
        [_detailBtn setTitle:@"未开播" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:k_Color3 forState:UIControlStateNormal];
    } else {
        
        [_detailBtn setTitle:@"查看>" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:k_Color8 forState:UIControlStateNormal];
    }
    
    if ([self.dataModel couponSource_type] != CouponSourceTypeRedeemCode) {
        _codeLabel.hidden = YES;
    } else {
        _codeLabel.hidden = NO;
        _codeLabel.y = _nameLabel.bottomY + adaptToWidth(10);
        _codeLabel.text = dataModel.couponSourceCode;
    }
}

- (UIView *)viewForImage {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_space, 0, SCREEN_WIDTH - 2 * _space, adaptToWidth(105))];
    
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = adaptToWidth(6);
    view.layer.masksToBounds = YES;
    view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, view.width, view.height)];
    
    float tagY = view.height - adaptToWidth(42);    // _remindHeight
    
    float tagRadius = adaptToWidth(4);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(0, tagY) radius:tagRadius startAngle:M_PI * 0.5 endAngle:M_PI clockwise:NO]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(view.width, tagY) radius:tagRadius startAngle:-(M_PI * 0.5) endAngle:M_PI * 0.5 clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    
    [view.layer setMask:shapeLayer];
    
    return view;
}

- (UIImage *)imageForView:(UIView *)view {
    
    CGSize s = view.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

@end


@implementation UIView (BLAnimation)

/// 弹性动画 iOS9 later
- (void)springAnimation NS_AVAILABLE_IOS(9_0) {
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    springAnimation.stiffness = 100;
    springAnimation.damping = 8;
    springAnimation.mass = 1;
    springAnimation.initialVelocity = 0;
    springAnimation.duration = 1;           // springAnimation.settlingDuration
    springAnimation.fromValue = @(1.12);
    springAnimation.toValue = @(1);
    springAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:springAnimation forKey:nil];
}

@end
