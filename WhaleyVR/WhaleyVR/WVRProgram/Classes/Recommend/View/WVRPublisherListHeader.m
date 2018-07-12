//
//  WVRPublisherListHeader.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPublisherListHeader.h"
#import "WVRRecommendStyleHeader.h"

@interface WVRPublisherListHeader ()

@property (nonatomic, assign) float bgHeight;

@property (nonatomic, weak) UIView *mainView;

@property (nonatomic, weak) UIImageView *suspendHeaderImgV;
@property (nonatomic, weak) UIImageView *backgroundImgV;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UILabel *introLabel;

@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIView *animateView;

@end


@implementation WVRPublisherListHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureSelf];
        [self createMainView];
        
        [self createBGImageView];
        [self suspendHeaderImgV];
        
        [self createNameLabel];
        [self createCountLabel];
        [self createIntroLabel];
        [self createLine];
        [self createSortBotton];
        [self createAnimateView];
    }
    return self;
}

- (void)configureSelf {
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _bgHeight = adaptToWidth(125);
}

#pragma mark - UI

- (void)createMainView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _bgHeight, self.width, self.height - _bgHeight)];
    
    [self addSubview:view];
    _mainView = view;
}


- (void)createBGImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, adaptToWidth(125))];
    
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    
    [self addSubview:imgV];
    _backgroundImgV = imgV;
}

- (UIImageView *)suspendHeaderImgV {
    
    if (!_suspendHeaderImgV) {
        float len = adaptToWidth(70);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, len, len)];
        
        imgV.layer.cornerRadius = len / 2.f;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [UIColor whiteColor].CGColor;
        imgV.layer.borderWidth = 2;
        
        [self addSubview:imgV];
        imgV.center = CGPointMake(self.width / 2.f, _bgHeight);
        _suspendHeaderImgV = imgV;
    }
    
    return _suspendHeaderImgV;
}

- (void)createNameLabel {
    
    float len = adaptToWidth(45.5);
    float gap = adaptToWidth(10);
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = kFontFitForSize(15);
    label.textColor = k_Color3;
    label.text = @"标题";
    [label sizeToFit];
    float height = label.height;
    label.frame = CGRectMake(gap, len, self.width - 2 * gap, height);
    label.textAlignment = NSTextAlignmentCenter;
    
    [_mainView addSubview:label];
    _nameLabel = label;
}

- (void)createCountLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color7;
    label.text = @"粉丝";
    [label sizeToFit];
    float height = label.height;
    label.frame = CGRectMake(_nameLabel.x, _nameLabel.bottomY + adaptToWidth(3), _nameLabel.width, height);
    label.textAlignment = NSTextAlignmentCenter;
    
    [_mainView addSubview:label];
    _countLabel = label;
}

- (void)createIntroLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color6;
    label.text = @"描述";
    label.numberOfLines = 0;
    [label sizeToFit];
    float height = label.height;
    label.frame = CGRectMake(_nameLabel.x, _countLabel.bottomY + adaptToWidth(13), _nameLabel.width, height);
    
    [_mainView addSubview:label];
    _introLabel = label;
}

- (void)createSortBotton {
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, adaptToWidth(70), adaptToWidth(20));
        btn.bottomY = _mainView.height - adaptToWidth(11) - _line.height;
        btn.tag = 101 + i;
        [btn.titleLabel setFont:kFontFitForSize(15)];
        
        [btn addTarget:self action:@selector(sortBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:btn];
    }
    
    UIButton *btn1 = [self viewWithTag:101];
    [btn1 setTitle:@"最新发布" forState:UIControlStateNormal];
    [btn1 setTitleColor:k_Color1 forState:UIControlStateNormal];
    btn1.bottomX = self.width / 2.f - adaptToWidth(17);
    
    UIButton *btn2 = [self viewWithTag:102];
    [btn2 setTitle:@"最多播放" forState:UIControlStateNormal];
    [btn2 setTitleColor:k_Color3 forState:UIControlStateNormal];
    btn2.x = self.width / 2.f + adaptToWidth(17);
}

- (void)createAnimateView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(15), adaptToWidth(3))];
    
    view.layer.cornerRadius = view.height / 2.f;
    view.layer.masksToBounds = YES;
    view.backgroundColor = k_Color1;
    
    UIButton *btn1 = [self viewWithTag:101];
    view.y = btn1.bottomY + adaptToWidth(3);
    view.centerX = btn1.centerX;
    
    [_mainView addSubview:view];
    _animateView = view;
}

- (void)createLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, HEIGHT_SPLITE_LINE)];
    line.bottomY = _mainView.height;
    line.backgroundColor = k_Color10;
    
    [_mainView addSubview:line];
    _line = line;
}

#pragma mark - setter

- (void)setDataModel:(WVRPublisherDetailModel *)dataModel {
    
    _dataModel = dataModel;
    _nameLabel.text = _dataModel.cp.name;
    
    [self updateFansCount:_dataModel.cp.fansCount];
    
    _introLabel.text = _dataModel.cp.info;
    [_introLabel sizeToFit];
    
    [_suspendHeaderImgV wvr_setImageWithURL:[NSURL URLWithUTF8String:_dataModel.cp.headPic] placeholderImage:[UIImage imageNamed:@"default_publisher_icon"]];
    
    [_backgroundImgV wvr_setImageWithURL:[NSURL URLWithUTF8String:_dataModel.cp.backgroundPic] placeholderImage:HOLDER_IMAGE];
}

- (void)updateFansCount:(long)count {
    
    NSString *num = [WVRComputeTool numberToString:count];
    _countLabel.text = [NSString stringWithFormat:@"%@粉丝", num];
}

#pragma mark - action

- (void)sortBottonClick:(UIButton *)sender {
    
    NSInteger index = sender.tag - 101;
    
    [self listViewDidChangeToType:index];
    
    if ([self.realDelegate respondsToSelector:@selector(sortBottonClickWithType:)]) {
        
        [self.realDelegate sortBottonClickWithType:index];
    }
}

- (void)listViewDidChangeToType:(PublisherSortType)type {
    
    UIButton *btn1 = [self viewWithTag:101];
    UIButton *btn2 = [self viewWithTag:102];
    BOOL isBtn1 = (type == PublisherSortTypePublishTime);
    
    [btn1 setTitleColor:(isBtn1 ?  k_Color1 : k_Color3) forState:UIControlStateNormal];
    [btn2 setTitleColor:(isBtn1 ?  k_Color3 : k_Color1) forState:UIControlStateNormal];
    
    [self sortStatusChangeAnimation:type];
}

- (void)sortStatusChangeAnimation:(NSInteger)index {
    
    UIButton *btn = [self viewWithTag:101 + index];
    float x = btn.centerX;
    
    [UIView animateWithDuration:0.3 animations:^{
        _animateView.centerX = x;
    }];
}

@end
