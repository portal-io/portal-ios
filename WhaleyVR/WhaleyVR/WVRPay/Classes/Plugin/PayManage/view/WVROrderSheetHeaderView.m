//
//  WVROrderSheetHeaderView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVROrderSheetHeaderView.h"
#import "SQDateTool.h"
#import "WVROrderActionSheet.h"

@interface WVROrderSheetHeaderView () {
    
    float _spaceLength;
}

@property (nonatomic, weak) WVRPayModel *payModel;
@property (nonatomic, assign) OrderAlertType type;

@property (nonatomic, assign) WVRPayGoodsType goodsType;

@property (nonatomic, assign) BOOL canPayWithJingbi;

@property (nonatomic, weak) UILabel *remindLabel;

@property (nonatomic, weak) UILabel *wcBalanceLabel;

@property (nonatomic, weak) WVROrderGoodsSelectLabel *packgeGoodsLabel;

@end


NSString *kGoodsNameSuffix = @" 观看券";

@implementation WVROrderSheetHeaderView

- (instancetype)initWithFrame:(CGRect)frame payModel:(WVRPayModel *)payModel type:(OrderAlertType)type canPayWithJingbi:(BOOL)canPayWithJingbi {
    self = [super initWithFrame:frame];
    if (self) {
        
        _payModel = payModel;
        _type = type;
        _canPayWithJingbi = canPayWithJingbi;
        
        _spaceLength = adaptToWidth(10);
        
        _goodsType = [payModel payGoodsType];
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    float headViewHeight = adaptToWidth(152);
    if ([_payModel isProgramAndPackage]) {    // 可选节目或节目包
        if (_canPayWithJingbi) {
            
            headViewHeight = adaptToWidth(225);
        } else {
            
            headViewHeight = adaptToWidth(218);
        }
    }
    
    self.height = headViewHeight;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = adaptToWidth(6);
    self.clipsToBounds = YES;
    
    float remindHeight = adaptToWidth(42);
    float tagY = self.height - remindHeight;
    float centerX = self.width * 0.5;
    float titleCenterY = adaptToWidth(17);
    
    // headView's subview width
    float sub_width = self.frame.size.width - 2 * _spaceLength;
    
    [self createTitleViewWithCenterX:centerX titleCenterY:titleCenterY];
    
    [self createSelectLabels];
    
    [self createStatusLabelWithY:tagY];
    
    if (self.payModel.payComeFromType!=WVRPayComeFromTypeWCurrency) {
        [self installCircularBeadAndImaginaryLine:tagY];
    }
    [self createRemindLabelWithRect:CGRectMake(_spaceLength, tagY, sub_width, remindHeight)];
    [self createWhaleyCurrencyBalanceLabelWithRect:CGRectMake(_spaceLength, tagY, sub_width, remindHeight)];
}

- (void)installCircularBeadAndImaginaryLine:(CGFloat)tagY
{
    float centerX = self.width * 0.5;
    float sub_width = self.frame.size.width - 2 * _spaceLength;
    [self createCircularBeadWithY:tagY];
    
    [self createImaginaryLineWithY:tagY centerX:centerX sub_width:sub_width];
}

- (void)createTitleViewWithCenterX:(float)centerX titleCenterY:(float)titleCenterY {
    
    // title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(85), adaptToWidth(20))];
    titleLabel.center = CGPointMake(centerX, titleCenterY);
    titleLabel.text = @"订单";
    titleLabel.textColor = k_Color8;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFontFitForSize(10);
    
    [self addSubview:titleLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_spaceLength, 0, titleLabel.x - _spaceLength, 1)];
    line1.centerY = titleLabel.centerY;
    line1.backgroundColor = titleLabel.textColor;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.bottomX, line1.y, line1.width, line1.height)];
    line2.backgroundColor = titleLabel.textColor;
    [self addSubview:line2];
}

- (void)createSelectLabels {
    
    GoodsSelectType type = GoodsSelectTypeNone;
    
    WVRPayGoodsType goodsType = _goodsType;
    
    if (_goodsType == WVRPayGoodsTypeProgramAndPackage) {
        
        _selectedType = WVRPayGoodsTypeProgramPackage;
        goodsType = WVRPayGoodsTypeProgram;
        type = GoodsSelectTypeAlternative;
    } else {
        _selectedType = _goodsType;
    }
    
    [self createGoodsLabel:type goodsType:goodsType];
    
    if (_goodsType == WVRPayGoodsTypeProgramAndPackage) {
        
        [self createPackgeGoodsLabel];
    }
}

- (void)createGoodsLabel:(GoodsSelectType)selectType goodsType:(WVRPayGoodsType)goodsType {
    
    float height = [WVROrderGoodsSelectLabel miniHeight];
    if (_goodsType == WVRPayGoodsTypeProgramAndPackage) {
        if (_canPayWithJingbi) {
            
            height = [WVROrderGoodsSelectLabel selectHeight];
        } else {
            height = [WVROrderGoodsSelectLabel normalHeight];
        }
    }
    BOOL needHideDetail = ((_payModel.fromType == PayFromTypeUnity) || (_payModel.payComeFromType == WVRPayComeFromTypeProgramPackage));
    
    NSString *title = _payModel.goodsName;
    if ([_payModel.relatedType isEqualToString:GOODS_TYPE_CONTENT_PACKGE] && (_payModel.payComeFromType != WVRPayComeFromTypeProgramPackage)) {
        title = nil;
    }
    
    WVROrderGoodsSelectLabel *label = [[WVROrderGoodsSelectLabel alloc] initWithFrame:CGRectMake(_spaceLength, adaptToWidth(35), self.width - 2 * _spaceLength, height) price:_payModel.goodsPrice title:title selectStatus:selectType type:goodsType packageType:_payModel.packageType needHideDetail:needHideDetail jingbiPrice:_canPayWithJingbi ? _payModel.jingbiPrice : nil];
    
    [self addSubview:label];
    _goodsLabel = label;
}

// 用户可以同时选择节目或者节目包时才会显示第二个选项label
- (void)createPackgeGoodsLabel {
    
    BOOL needHideDetail = ((_payModel.fromType == PayFromTypeUnity) || (_payModel.payComeFromType == WVRPayComeFromTypeProgramPackage));
    
    WVROrderGoodsSelectLabel *label = [[WVROrderGoodsSelectLabel alloc] initWithFrame:CGRectMake(_goodsLabel.x, _goodsLabel.bottomY, _goodsLabel.width, [WVROrderGoodsSelectLabel normalHeight]) price:[_payModel.programPackModel price] title:nil selectStatus:GoodsSelectTypeSelected type:WVRPayGoodsTypeProgramPackage packageType:_payModel.packageType needHideDetail:needHideDetail jingbiPrice:_canPayWithJingbi ? _payModel.jingbiPrice : nil];
    
    label.clipsToBounds = YES;
    _goodsLabel.clipsToBounds = YES;
    
    [self addSubview:label];
    _packgeGoodsLabel = label;
}

- (void)createStatusLabelWithY:(float)tagY {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_spaceLength, 0, self.width - 2 * _spaceLength, adaptToWidth(20))];
    label.font = kFontFitForSize(13);
    
    switch (_type) {
        case OrderAlertTypeResultSuccess: {
            
            label.textColor = Color_RGB(136, 207, 81);
            
            if (_payModel.payPlatform == WVRPayPlatformWhaleyCurrency) {
                label.text = @"鲸币支付成功";
            } else {
                label.text = @"支付成功";
            }
        }
            break;
        case OrderAlertTypePayment: {
            
            label.textColor = k_Color15;
            label.text = @"待支付";
        }
            break;
        case OrderAlertTypeResultFailed: {
            
            label.textColor = k_Color15;
            label.text = @"支付失败";
        }
            break;
            
        default:
            break;
    }
    
    [label sizeToFit];
    label.bottomY = tagY - adaptToWidth(18);
    
    [self addSubview:label];
    _statusLabel = label;
}

// 圆角缺口
- (void)createCircularBeadWithY:(float)tagY {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    
    float tagRadius = adaptToWidth(4);
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(0, tagY) radius:tagRadius startAngle:M_PI * 0.5 endAngle:M_PI clockwise:NO]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width, tagY) radius:tagRadius startAngle:-(M_PI * 0.5) endAngle:M_PI * 0.5 clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    [self.layer setMask:shapeLayer];
}

// 虚线
- (void)createImaginaryLineWithY:(float)tagY centerX:(float)centerX sub_width:(float)sub_width {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, sub_width, 1)];
    [shapeLayer setPosition:CGPointMake(centerX, tagY - 0.5)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[k_Color8 CGColor]];
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
    
    [self.layer addSublayer:shapeLayer];
}

- (void)createRemindLabelWithRect:(CGRect)rect {
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:rect];
    remindLabel.textColor = k_Color8;
    remindLabel.font = kFontFitForSize(11);
    
    remindLabel.text = [self programTypeIntr];
    [self addSubview:remindLabel];
    _remindLabel = remindLabel;
    
    if (_packgeGoodsLabel) {
        _remindLabel.hidden = YES;
    }
}

- (void)createWhaleyCurrencyBalanceLabelWithRect:(CGRect)rect {
    
    if (!_canPayWithJingbi || !self.payModel.jingbiPrice || _type != OrderAlertTypePayment) {
        return;
    }
    
    UILabel *wcBalanceLabel = [[UILabel alloc] initWithFrame:rect];
    wcBalanceLabel.textColor = k_Color6;
    wcBalanceLabel.font = kFontFitForSize(11);
    wcBalanceLabel.textAlignment = NSTextAlignmentRight;
    
    wcBalanceLabel.text = [NSString stringWithFormat:@"(鲸币余额:%ld)", [WVRUserModel sharedInstance].wcBalance];
    [self addSubview:wcBalanceLabel];
    _wcBalanceLabel = wcBalanceLabel;
    
//    if (_packgeGoodsLabel) {
//        _wcBalanceLabel.hidden = YES;
//    }
}

#pragma mark - pravite func

- (NSString *)programTypeIntr {
    
    NSString * resultIntr = @"";
    NSString * disableTime = @"";
    if (self.payModel.payComeFromType == WVRPayComeFromTypeProgramLive) {
        resultIntr = [NSString stringWithFormat:@"*购买后，同时取得直播回顾的观看权"];
    } else if (self.payModel.payGoodsType != WVRPayGoodsTypeProgramPackage) {
        if (self.payModel.disableTime > 0) {
            disableTime = [SQDateTool year_month_day_ch:self.payModel.disableTime];
            resultIntr = [NSString stringWithFormat:@"*视频版权期限截止至%@", disableTime];
        } else {
            resultIntr = @"";
        }
    } else {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        resultIntr = [@"订单日期 " stringByAppendingString:[SQDateTool year_month_day_ch:time]];
    }
    
    return resultIntr;
}

#pragma mark - private

- (void)selectLabelTapAction:(WVROrderGoodsSelectLabel *)label {
    
    _selectedType = label.type;
    
    if (label == self.goodsLabel) {
        [self.packgeGoodsLabel resetSelectStatus];
        _remindLabel.hidden = NO;
    } else {
        [self.goodsLabel resetSelectStatus];
        _remindLabel.hidden = YES;
    }
    self.packgeGoodsLabel.y = self.goodsLabel.bottomY;
}

- (void)goPackgeDetailVC {
    
    WVROrderActionSheet *sheet = (WVROrderActionSheet *)self.superview;
    
    if (![sheet isKindOfClass:[WVROrderActionSheet class]]) {
        DDLogError(@"WVROrderActionSheet 用法错误");
        return;
    }
    
    if ([sheet.realDelegate respondsToSelector:@selector(jumpToProgramPackageVC)]) {
            
        [sheet dismiss:^{
            [sheet.realDelegate jumpToProgramPackageVC];
        }];
    }
}

@end


@interface WVROrderGoodsSelectLabel ()

@property (nonatomic, assign) long price;
@property (nonatomic, strong) NSNumber *jingbiPrice;
@property (nonatomic, assign) BOOL needHideDetail;
@property (nonatomic, assign) GoodsSelectType status;
@property (nonatomic, assign) WVRPackageType packageType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UIButton *packgeDetailBtn;

@property (nonatomic, weak) UILabel *priceLabel;

@end


@implementation WVROrderGoodsSelectLabel

- (instancetype)initWithFrame:(CGRect)frame price:(long)price title:(NSString *)title selectStatus:(GoodsSelectType)selectStatus type:(WVRPayGoodsType)type packageType:(WVRPackageType)packageType needHideDetail:(BOOL)needHideDetail jingbiPrice:(NSNumber *)jingbiPrice {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _price = price;
        _jingbiPrice = jingbiPrice;
        _title = title;
        _needHideDetail = needHideDetail;
        _status = selectStatus;
        _packageType = packageType;
        
        [self drawUI];
        
        [self addTapAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL isMiniHeight = (self.height == [WVROrderGoodsSelectLabel miniHeight]);
    BOOL isNormalHeight = (self.height == [WVROrderGoodsSelectLabel normalHeight]);
    
    float secondViewCenterY = adaptToWidth(50);
    
    if (isNormalHeight || isMiniHeight) {
        
        for (UIView *view in self.subviews) {
            if (view.tag == 1) {
                view.centerY = secondViewCenterY;
            } else {
                view.centerY = self.height * 0.5f;
            }
        }
    } else {
        
        for (UIView *view in self.subviews) {
            if (view.tag == 1) {
                view.centerY = secondViewCenterY;
            } else {
                view.centerY = [WVROrderGoodsSelectLabel normalHeight] * 0.5f + fitToWidth(2);
            }
        }
    }
}

- (void)drawUI {
    
    if (_status != GoodsSelectTypeNone) {
        [self createImageView];
    }
    
    [self createPriceLabel];
    [self createJingbiPriceLabel];
    
    [self createTitleLabel];
    
    if (_title == nil) {    // 符合特定条件
        [self createPackgeDetailBtn];
    } else {
        switch (_type) {
            case WVRPayGoodsTypeProgramPackage:
                if (_packageType == WVRPackageTypeProgramSet) {
                    [self createPackgeDetailBtn];
                }
                break;
            
            default:
                break;
        }
    }
}

- (void)addTapAction {
    
    if (GoodsSelectTypeNone == _status) { return; }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self addGestureRecognizer:tap];
}

- (void)createImageView {
    
    float imgH = adaptToWidth(18);
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(12), 0, imgH, imgH)];
    
    [self addSubview:imgV];
    _iconView = imgV;
    
    if (_status ==  GoodsSelectTypeAlternative) {
        
        [self resetSelectStatus];
    } else if (_status ==  GoodsSelectTypeSelected) {
        
        [self selectStatus];
    }
}

- (void)createTitleLabel {
    
    WVROrderGoodsNameLabel *label = [[WVROrderGoodsNameLabel alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.65, self.height)];
    label.textColor = k_Color3;
    label.font = kBoldFontFitSize(15);
    if (_title) {
        
        label.text = _title;
    } else if (_packageType == WVRPackageTypeProgramPackage) {
        
        label.text = @"购买该节目包(推荐)";
    } else if (_packageType == WVRPackageTypeProgramSet) {
        label.text = @"购买该合集";
    }
    [label sizeToFit];
    label.centerY = self.height * 0.5;
    
    if (label.width > self.width * 0.65) {
        label.width = self.width * 0.65;
    }
    
    label.x = (_status == GoodsSelectTypeNone) ? 0 : (_iconView.bottomX + adaptToWidth(10));
    
    [self addSubview:label];
    _nameLabel = label;
}

- (void)createPackgeDetailBtn {
    
    if (_needHideDetail) { return; }
    
    if (_nameLabel.width > self.width * 0.5) {
        _nameLabel.width = self.width * 0.5;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 初始化的时候就是选中的状态
    if (self.height == [WVROrderGoodsSelectLabel selectHeight]) {
        btn.tag = 1;
    }
    
    float x = (1 == btn.tag) ? _nameLabel.x : _nameLabel.bottomX + adaptToWidth(10);
    
    btn.frame = CGRectMake(x, 0, adaptToWidth(55), [[self class] normalHeight]);
    [btn setTitle:@"查看详情>" forState:UIControlStateNormal];
    [btn setTitleColor:k_Color6 forState:UIControlStateNormal];
    btn.titleLabel.font = kFontFitForSize(11);
    
    [btn addTarget:self action:@selector(packgeDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    _packgeDetailBtn = btn;
}

- (void)createPriceLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color20;
    label.font = _nameLabel.font;
    label.text = [@"￥" stringByAppendingString:[WVRComputeTool numToPriceNumber:_price]];
    [label sizeToFit];
    
//    label.centerY = self.height * 0.5;
    label.bottomX = self.width - adaptToWidth(8);
    
    [self addSubview:label];
    _priceLabel = label;
}

- (void)createJingbiPriceLabel {
    
    if (!_jingbiPrice) {
        return;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color6;
    label.font = kFontFitForSize(13.5);
    label.text = [NSString stringWithFormat:@"%@ 鲸币", _jingbiPrice];
    [label sizeToFit];
    
    label.tag = 1;
    
//    label.y = fitToWidth(40);
    label.bottomX = _priceLabel.bottomX;
    
    [self addSubview:label];
}

- (void)selectStatus {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.iconView.image = [UIImage imageNamed:@"goods_select_selected"];
    
    if (_jingbiPrice) {
        
        self.packgeDetailBtn.tag = 1;
        self.packgeDetailBtn.x = _nameLabel.x;
        
        self.height = [WVROrderGoodsSelectLabel selectHeight];
    }
}

#pragma mark - action

- (void)tapAction {
    
    [self selectStatus];
    
    WVROrderSheetHeaderView *view = (WVROrderSheetHeaderView *)self.superview;
    
    if ([view isKindOfClass:[WVROrderSheetHeaderView class]]) {
        [view selectLabelTapAction:self];
    }
}

- (void)packgeDetailBtnClick:(UIButton *)sender {
    
    WVROrderSheetHeaderView *view = (WVROrderSheetHeaderView *)self.superview;
        
    if ([view isKindOfClass:[WVROrderSheetHeaderView class]]) {
        [view goPackgeDetailVC];
    }
}

#pragma mark - external func

- (void)resetSelectStatus {
    
    self.backgroundColor = [UIColor clearColor];
    self.iconView.image = [UIImage imageNamed:@"goods_select_normal"];
    
    if (_jingbiPrice) {
        
        self.packgeDetailBtn.tag = 0;
        self.packgeDetailBtn.x = _nameLabel.bottomX + adaptToWidth(10);
        
        self.height = [WVROrderGoodsSelectLabel normalHeight];
    }
}

//- (void)setIsFormUnity:(BOOL)isUnity {
//    if (isUnity) {
//        self.packgeDetailBtn.hidden = YES;
//    }
//}

/** 只显示文字，不选择时的高度 */
+ (float)miniHeight {
    
    return adaptToWidth(18);
}

/** 未选择时高度 */
+ (float)normalHeight{

    return adaptToWidth(40);
}

/** 已选择时高度 */
+ (float)selectHeight {
    
    return adaptToWidth(70);
}

@end


@interface WVROrderGoodsNameLabel ()

@property (nonatomic, weak) UILabel *suffixLabel;
@property (nonatomic, weak) UILabel *prefixLabel;
@property (nonatomic, assign) float tmpWidth;

@end


@implementation WVROrderGoodsNameLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tmpWidth = self.frame.size.width;
        
        [self createPrefixLabel];
        [self createSuffixLabel];
    }
    return self;
}

- (void)createPrefixLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    
    [self addSubview:label];
    _prefixLabel = label;
}

- (void)createSuffixLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    
    [self addSubview:label];
    _suffixLabel = label;
}

- (void)layoutSubviews {
    
    if (_tmpWidth != self.frame.size.width) {
        
        [self dealWithText];
        
        _tmpWidth = self.frame.size.width;
    }
}

- (void)setText:(NSString *)text {
    
    _text = text;
    
    [self dealWithText];
}

- (void)dealWithText {
    
    float width = [WVRComputeTool sizeOfString:self.text Size:CGSizeMake(800, 800) Font:self.font].width;
    
    if (width > self.frame.size.width && [_text hasSuffix:kGoodsNameSuffix]) {
        
        _suffixLabel.text = kGoodsNameSuffix;
        _prefixLabel.text = [_text substringToIndex:(_text.length - kGoodsNameSuffix.length)];
        
    } else {
        
        _suffixLabel.text = @"";
        _prefixLabel.text = _text;
    }
    
    _suffixLabel.width = [WVRComputeTool sizeOfString:_suffixLabel.text Size:CGSizeMake(800, 800) Font:self.font].width;
    
    _suffixLabel.bottomX = self.width;
    _prefixLabel.width = self.width - _suffixLabel.width;
}

#pragma mark - setter

- (void)setFont:(UIFont *)font {
    
    [_suffixLabel setFont:font];
    [_prefixLabel setFont:font];
    
    _font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    
    [_suffixLabel setTextColor:textColor];
    [_prefixLabel setTextColor:textColor];
    
    _textColor = textColor;
}

- (void)sizeToFit {
    
    float width = [WVRComputeTool sizeOfString:self.text Size:CGSizeMake(800, 800) Font:self.font].width;
    if (self.frame.size.width > width) {
        self.width = width;
    }
}

@end
