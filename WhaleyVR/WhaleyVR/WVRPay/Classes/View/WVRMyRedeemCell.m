//
//  WVRMyRedeemCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyRedeemCell.h"

@interface WVRMyRedeemCell () {
    
    float _gap;
}

@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *markLabel;
@property (nonatomic, weak) UIButton *exchangeBtn;

@end


#define SHOW_TYPE_PHONE @"预留号码关联"
#define SHOW_TYPE_ACTIVITY @"活动"


@implementation WVRMyRedeemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _gap = adaptToWidth(10);
        
        [self drawUI];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//}

#pragma mark - setter

- (void)setDataModel:(WVRRedeemCodeListItemModel *)dataModel {
    _dataModel = dataModel;
    
    _nameLabel.text = dataModel.redeemCode;
    CGSize size = [WVRComputeTool sizeOfString:_nameLabel.text Size:CGSizeMake(800, 800) Font:_nameLabel.font];
    _nameLabel.width = size.width;
    
    switch (dataModel.showType) {
        case WVRRedeemCodeShowTypePhone:
            _markLabel.text = SHOW_TYPE_PHONE;
            break;
            
        case WVRRedeemCodeShowTypeActivity:
            _markLabel.text = SHOW_TYPE_ACTIVITY;
            break;
        default:
            break;
    }
    
    size = [WVRComputeTool sizeOfString:_markLabel.text Size:CGSizeMake(800, 800) Font:_markLabel.font];
    _markLabel.x = _nameLabel.bottomX + _gap;
    _markLabel.width = size.width + _gap;
}

- (void)setIsLastCell:(BOOL)isLast {
    
    // 最后一个下面有圆角效果，其他的没有
    
}

#pragma mark - getter

- (UIView *)mainView {
    
    if (!_mainView) {
        float x = adaptToWidth(15);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH - 2 * x, adaptToWidth(50))];
        
        view.backgroundColor = k_Color10;
        view.layer.borderColor = k_Color8.CGColor;
        view.layer.borderWidth = 0.5;
        
        [self addSubview:view];
        _mainView = view;
    }
    return _mainView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_gap, 0, 75, self.mainView.height)];
        label.font = kFontFitForSize(18);
        label.textColor = k_Color1;
        label.text = @"ZC21SU";
        
        [self.mainView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)markLabel {
    
    if (!_markLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.bottomX + _gap, 0, adaptToWidth(85), adaptToWidth(20))];
        label.font = kFontFitForSize(11);
        label.backgroundColor = k_Color9;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = fitToWidth(4);
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.centerY = self.mainView.height * 0.5;
        
        label.text = SHOW_TYPE_PHONE;

        [self.mainView addSubview:label];
        _markLabel = label;
    }
    return _markLabel;
}

- (UIButton *)exchangeBtn {
    
    if (!_exchangeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, adaptToWidth(60), adaptToWidth(31));
        btn.bottomX = self.mainView.width - _gap;
        [btn setTitle:@"兑换" forState:UIControlStateNormal];
        [btn setTitleColor:k_Color8 forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFontFitForSize(17)];
        
        btn.centerY = self.mainView.height * 0.5;
        
        btn.layer.cornerRadius = fitToWidth(4);
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = k_Color8.CGColor;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(exchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainView addSubview:btn];
        _exchangeBtn = btn;
    }
    return _exchangeBtn;
}

#pragma mark - UI

- (void)drawUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self mainView];
    [self nameLabel];
    [self markLabel];
    [self exchangeBtn];
}

#pragma mark - action

- (void)exchangeButtonClick {
    
    if ([self.realDelegate respondsToSelector:@selector(redeemCellExchangeClick:)]) {
        [self.realDelegate redeemCellExchangeClick:_dataModel];
    }
}

@end


@interface WVRUnExchangeCodeHeader ()

@end


@implementation WVRUnExchangeCodeHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, adaptToWidth(75));
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self configureSubview];
    }
    return self;
}

- (void)configureSubview {
    
    [self createExchangeBtn];
    [self addGesture];
}

- (void)createExchangeBtn {
    
    float x = adaptToWidth(15);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.width - 2 * x, adaptToWidth(50))];
    label.bottomY = self.height;
    
    label.layer.cornerRadius = adaptToWidth(4);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = k_Color8.CGColor;
    label.layer.masksToBounds = YES;
    label.userInteractionEnabled = YES;
    
    label.text = @"  请输入兑换码";
    label.font = kFontFitForSize(15);
    label.textColor = k_Color8;
    
    label.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:label];
    _remindLabel = label;
}

- (void)addGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [_remindLabel addGestureRecognizer:tap];
}

#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if ([self.realDelegate respondsToSelector:@selector(headerExchangeButtonClick)]) {
        [self.realDelegate headerExchangeButtonClick];
    }
}

@end
