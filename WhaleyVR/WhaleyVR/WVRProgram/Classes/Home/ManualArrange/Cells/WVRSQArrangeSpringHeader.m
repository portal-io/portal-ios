//
//  WVRSQArrangeSpringHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQArrangeSpringHeader.h"
#import "WVRImageTool.h"

@interface WVRSQArrangeSpringHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *intrDesL;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgV;
@property (weak, nonatomic) UIButton *myCardBtn;

@property (nonatomic) WVRSQArrangeMAHeaderInfo * cellInfo;

@end


@implementation WVRSQArrangeSpringHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.intrDesL.numberOfLines = 3;
    self.intrDesL.font = kFontFitForSize(12);
    self.intrDesL.textColor = k_Color_hex(0xae8143);
    
    [self.bottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(fitToWidth(100.7));
        make.bottom.equalTo(self).offset(fitToWidth(-33));
    }];
    
    [self.thubImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.bottomImgV.mas_top);
    }];
    
    [self.intrDesL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.lessThanOrEqualTo(@(fitToWidth(75)));
        make.width.equalTo(self).offset(fitToWidth(-100));
        make.centerX.equalTo(self.bottomImgV);
        make.bottom.equalTo(self.bottomImgV).offset(fitToWidth(-12));
    }];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addLine];
    
    [self myCardBtn];
}

- (void)addLine {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = k_Color_hex(0xdaa154);
    
    [self addSubview:view];
    
    kWeakSelf(self);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(fitToWidth(1)));
        make.top.equalTo(weakself.bottomImgV.mas_bottom);
        make.left.equalTo(weakself);
        make.right.equalTo(weakself);
    }];
}

- (UIButton *)myCardBtn {
    if (!_myCardBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        
        [btn addTarget:self action:@selector(myCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btn.superview).offset(fitToWidth(-39));
            make.width.mas_equalTo(fitToWidth(70));
            make.height.mas_equalTo(fitToWidth(25));
            make.bottom.equalTo(btn.superview).offset(fitToWidth(-104));
        }];
    }
    return _myCardBtn;
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRSQArrangeMAHeaderInfo *)info;
    
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[WVRImageTool parseImageUrl:self.cellInfo.sectionModel.thubImageUrl scaleSize:_thubImageV.size]] placeholderImage:HOLDER_IMAGE];
    NSString *string = self.cellInfo.sectionModel.intrDesc ?: @"";
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.intrDesL.attributedText = attrString;
    
    [self.bottomImgV setImage:[UIImage imageNamed:@"icon_spring2018_paper"]];
}

/// just for UnityTemp View
- (void)setSectionModel:(WVRSectionModel *)sectionModel {
    
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[WVRImageTool parseImageUrl:sectionModel.thubImageUrl scaleSize:_thubImageV.size]] placeholderImage:HOLDER_IMAGE];
    NSString *string = sectionModel.intrDesc ?: @"";
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.intrDesL.attributedText = attrString;
}

#pragma mark - action

- (void)myCardBtnClicked:(UIButton *)sender {
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}

@end
