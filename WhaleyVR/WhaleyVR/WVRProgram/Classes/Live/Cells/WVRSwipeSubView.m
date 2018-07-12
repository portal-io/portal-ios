//
//  WVRSwipeSubView.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSwipeSubView.h"
#import "UIColor+UIHexColor.h"
#import "WVRWidgetColorHeader.h"

@interface WVRSwipeSubView ()

@property (nonatomic) CAGradientLayer *mGradientLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *liveStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end


@implementation WVRSwipeSubView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //据底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    // 设置渐变效果
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.width, 2*self.liveStatusBtn.centerY);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithWhite:0 alpha:0.3] CGColor],
                            (id)[[UIColor colorWithWhite:0 alpha:0] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.imageV.layer addSublayer:gradientLayer];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = fitToWidth(3.0f);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = fitToWidth(3.0f);
    
//    NSLayoutConstraint * conLead = [NSLayoutConstraint constraintWithItem:gradientLayer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:fitToWidth(2)];
//    NSLayoutConstraint * conTra = [NSLayoutConstraint constraintWithItem:gradientLayer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:fitToWidth(2)];
//    NSLayoutConstraint * conTop = [NSLayoutConstraint constraintWithItem:gradientLayer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:fitToWidth(2)];
//    NSLayoutConstraint * conH = [NSLayoutConstraint constraintWithItem:gradientLayer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2*self.liveStatusBtn.centerY];
//    [self addConstraints:@[conTop,conLead,conTra,conH]];
    
    self.mGradientLayer = gradientLayer;
    self.liveStatusBtn.layer.masksToBounds = YES;
    self.liveStatusBtn.layer.cornerRadius = self.liveStatusBtn.height/2.0f;
    self.liveStatusBtn.layer.borderWidth = 1.0f;
    self.liveStatusBtn.layer.borderColor = UIColorFromRGBA(0xffffff, 0.3).CGColor;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapResponse:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapG];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateLayFrame];
}

- (void)updateLayFrame {
    
    CGRect frame = self.mGradientLayer.frame;
    frame.size.width = self.width;
    self.mGradientLayer.frame = frame;
}

- (void)onTapResponse:(UITapGestureRecognizer *)tapG {
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:self];
    }
}

- (void)fillData:(WVRSwipeSubViewInfo *)info {
    
    self.nameL.text = info.name;
    [self.imageV wvr_setImageWithURL:[NSURL URLWithString:info.imageStr] placeholderImage:HOLDER_IMAGE];
    if (info.derscStr.length==0
        ) {
        self.liveStatusBtn.hidden = YES;
    }else{
        self.liveStatusBtn.hidden = NO;
        [self.liveStatusBtn setTitle:info.derscStr forState:UIControlStateNormal];
    }
}

//- (void)updateImageV:(NSString*)imageStr
//{
//    [self.imageV wvr_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:HOLDER_IMAGE];
//}

@end


@implementation WVRSwipeSubViewInfo

@end
