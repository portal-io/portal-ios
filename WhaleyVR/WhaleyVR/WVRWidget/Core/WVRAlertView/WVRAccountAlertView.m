//
//  WVRAccountAlertView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/27/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRAccountAlertView.h"

#import "YYText.h"

@interface WVRAccountAlertView ()

@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *ensureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *dividingLineH;
@property (nonatomic, strong) UIView *dividingLineV;

@end


@implementation WVRAccountAlertView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self selfConfig];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selfConfig
{
    [self setEnableBgTouchDisappear:YES];
    
    CGRect tmpRect = CGRectZero;
    
    tmpRect.size = [UIScreen mainScreen].bounds.size;
    [self setFrame:tmpRect];
}

- (void)allocSubviews
{
    _titleLabel = [[YYLabel alloc] init];

    _ensureButton = [[UIButton alloc] init];
    _cancelButton = [[UIButton alloc] init];
    
    _dividingLineH = [[UIView alloc] init];
    _dividingLineV = [[UIView alloc] init];

}

- (void)configSubviews
{
    /* Base board */
    [self.baseBoard setBackgroundColor:[UIColor whiteColor]];
    [self.baseBoard.layer setCornerRadius:5];
    [self.baseBoard clipsToBounds];
    
    /* Title Label */
    [_titleLabel setFont: kFontFitForSize(35/2)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.numberOfLines = 2;
    
    /* Ensure Button */
    [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ensureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ensureButton setTitleColor:[UIColor colorWithHex:0x2a2a2a alpha:0.5] forState:UIControlStateHighlighted];
    [_ensureButton.titleLabel setFont:kFontFitForSize(35/2)];
    [_ensureButton setClipsToBounds:YES];
    [_ensureButton.layer setCornerRadius:6];
    [_ensureButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ensureButton setTag:0];
    
    /* Ensure Button */
//    [_cancelButton setBackgroundColor:[UIColor colorWithHex:0x3389d9]];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithHex:0x2a2a2a alpha:0.5] forState:UIControlStateHighlighted];
    [_cancelButton.titleLabel setFont:kFontFitForSize(35/2)];
    [_cancelButton setClipsToBounds:YES];
    [_cancelButton.layer setCornerRadius:6];
    [_cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTag:1];
    
    _dividingLineH.backgroundColor = [UIColor colorWithHex:0xe3e3e3];
    _dividingLineV.backgroundColor = [UIColor colorWithHex:0xe3e3e3];
    
    [self.baseBoard addSubview:_titleLabel];
    [self.baseBoard addSubview:_ensureButton];
    [self.baseBoard addSubview:_cancelButton];
    [self.baseBoard addSubview:_dividingLineH];
    [self.baseBoard addSubview:_dividingLineV];
}

- (void)positionSubviews
{
    CGRect tmpRect = CGRectZero;
    
    /* Base board */
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(625/2) height:fitToWidth(181) toBottom:fitToWidth(270)];
    
    [self.baseBoard setFrame:tmpRect];
    
    /* Title Label */
    tmpRect = [self.baseBoard rectInSubviewWithWidth:self.baseBoard.width height:fitToWidth(110) toLeft:0 toTop:0];
    [_titleLabel setFrame:tmpRect];
    
    tmpRect = [self.baseBoard centerRectInSubviewWithWidth:self.baseBoard.width height:fitToWidth(1) toTop:_titleLabel.bottom];
    _dividingLineH.frame = tmpRect;
    
    /* Cancel Button */
    tmpRect = [self.baseBoard rectInSubviewWithWidth:self.baseBoard.width/2-fitToWidth(0.5) height:fitToWidth(70) toLeft:0 toTop:fitToWidth(111)];
    [_cancelButton setFrame:tmpRect];
    
    tmpRect = [self.baseBoard rectInSubviewWithWidth:fitToWidth(1) height:fitToWidth(70) toLeft:_cancelButton.right toTop:fitToWidth(111)];
    _dividingLineV.frame = tmpRect;
    
    /* Ensure Button */
    tmpRect = [self.baseBoard rectInSubviewWithWidth:self.baseBoard.width/2-fitToWidth(0.5) height:fitToWidth(70) toLeft:self.baseBoard.bounds.size.width/2+fitToWidth(0.5) toTop:fitToWidth(111)];
    [_ensureButton setFrame:tmpRect];
}

- (void)setTitle:(NSString*) title
{
    _titleLabel.text = title;
}

#pragma mark - Target-Action pair
- (void)buttonClicked:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(ensureView:buttonDidClickedAtIndex:)]) {
        [_delegate ensureView:self buttonDidClickedAtIndex:button.tag];
    }
}

@end
