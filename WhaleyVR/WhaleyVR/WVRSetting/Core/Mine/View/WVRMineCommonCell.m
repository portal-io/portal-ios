//
//  WVRAccountTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/2/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRMineCommonCell.h"
#import "WVRMineCommonCellViewModel.h"


@interface WVRMineCommonCell()

@property (nonatomic, strong) WVRMineCommonCellViewModel * gViewModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) UIImageView *goinImageView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic) UIView * rewardDotV;

@end


@implementation WVRMineCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self allocSubviews];
        [self selfConfig];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)bindViewModel:(id)viewModel
{
    self.gViewModel = viewModel;
    [self selfConfig];
    [self configSubviews];
    [self positionSubviews];
    @weakify(self);
    [RACObserve(self, gViewModel) subscribeNext:^(WVRMineCommonCellViewModel *viewModel) {
        @strongify(self);
        self.rewardDotV.hidden = viewModel.rewardDotHidden;
        self.bottomLine.hidden = viewModel.bLineHidden;
        self.titleLabel.text = viewModel.title;
        self.subTitleLabel.text = viewModel.subTitle;
        self.iconImageView.image = [[UIImage alloc] init];
        self.goinImageView.image = [UIImage imageNamed:viewModel.goinIcon];
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
//    RAC(self.frame.size, height) = RACObserve(self.gViewModel, cellHeight);
    [self positionSubviews];
}

#pragma mark - UI 

- (void)selfConfig {
    
    [self setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)allocSubviews {
    
    _titleLabel = [[UILabel alloc] init];
    self.subTitleLabel = [[UILabel alloc] init];
    _rewardDotV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fitToWidth(10), fitToWidth(10))];
    _rewardDotV.layer.masksToBounds = YES;
    _rewardDotV.layer.cornerRadius = fitToWidth(10) / 2.f;
    _rewardDotV.centerY = fitToWidth(58.5) / 2.f;
    _rewardDotV.hidden = YES;
    _iconImageView = [[UIImageView alloc] init];
    _goinImageView = [[UIImageView alloc] init];
    
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews {
    
    /* Title */
    [_titleLabel setText:@"浏览历史"];
    [_titleLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_titleLabel setFont:kFontFitForSize(15)];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.subTitleLabel.textColor = k_Color5;
    self.subTitleLabel.font = kFontFitForSize(12.5f);
    _iconImageView.image = [UIImage imageNamed:@"icon_setting"];
    _goinImageView.image = [UIImage imageNamed:@"find_icon_more"];
    _bottomLine.backgroundColor = k_Color9;
    _rewardDotV.backgroundColor = [UIColor redColor];
    
    [self addSubview:_titleLabel];
    [self addSubview:_iconImageView];
    [self addSubview:_goinImageView];
    [self addSubview:_bottomLine];
    [self addSubview:_rewardDotV];
    [self addSubview:self.subTitleLabel];
}

- (void)positionSubviews {
    
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:_iconImageView.image.size.width height:_iconImageView.image.size.height toLeft:15];
    _iconImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_titleLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:40];
    _titleLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(12.f/2) height:fitToWidth(22.f/2) toRight:_titleLabel.x];
    _goinImageView.frame = tmpRect;
    
    _rewardDotV.x = _goinImageView.x - fitToWidth(5) - _rewardDotV.width;
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH - _titleLabel.x*2 height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
    _bottomLine.x = _titleLabel.x;
    
    CGSize subTitlesize = [self labelTextSize:self.subTitleLabel];
    tmpRect = [self centerRectInSubviewWithWidth:subTitlesize.width height:subTitlesize.height toLeft:0];
    self.subTitleLabel.frame = tmpRect;
    self.subTitleLabel.x = _goinImageView.x - self.subTitleLabel.width - fitToWidth(15);
}

- (CGSize)labelTextSize:(UILabel *)label {
    
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x - 10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (void)setBottomLineHidden {
    
    _bottomLine.hidden = YES;
}

#pragma mark - external func

- (void)updateRewardDoaV:(BOOL)hiden {
    
    _rewardDotV.hidden = hiden;
}

- (void)updateCellWithIcon:(NSString *)icon
               title:(NSString *)title
                goin:(NSString *)goin {
    
    _iconImageView.image = [UIImage imageNamed:icon];
    _titleLabel.text = title;
    _goinImageView.image = [UIImage imageNamed:goin];
}

- (void)updateCellWithIcon:(NSString *)icon
                     title:(NSString *)title
                  subTitle:(NSString *)subTitle
                      goin:(NSString *)goin {
    
    _iconImageView.image = [UIImage imageNamed:icon];
    _titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    _goinImageView.image = [UIImage imageNamed:goin];
}

@end
