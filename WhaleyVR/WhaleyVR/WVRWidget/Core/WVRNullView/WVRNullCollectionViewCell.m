//
//  WVRLocalVideoNullTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 09/10/2016.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRNullCollectionViewCell.h"
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"
#import "UIColor+Extend.h"
#import "UIView+EasyLayout.h"

@interface WVRNullCollectionViewCell()

@property (nonatomic, strong) UIImageView *nullImageView;
@property (nonatomic, strong) UILabel     *nullTintLabel;
@property (nonatomic, assign) CGFloat xdis;

@end


@implementation WVRNullCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.xdis = 10;
        [self selfConfig];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)selfConfig
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.userInteractionEnabled = NO;
}

- (void)allocSubviews
{
    _nullImageView = [[UIImageView alloc] init];
    _nullTintLabel = [[UILabel alloc] init];
}

- (void)configSubviews
{
    /* NullTint */
    [_nullTintLabel setTextColor:[UIColor colorWithHex:0xd3d3d3]];
    [_nullTintLabel setFont:kFontFitForSize(30/2)];
    _nullTintLabel.numberOfLines = 2;
    _nullTintLabel.textAlignment = NSTextAlignmentCenter;
    _nullImageView.image = [UIImage imageNamed:@"icon_live_direct_null"];
    _nullImageView.contentMode = UIViewContentModeScaleAspectFit;
    _nullImageView.clipsToBounds = YES;
    [self.contentView addSubview:_nullImageView];
    [self.contentView addSubview:_nullTintLabel];
}

- (void)setTint:(NSString*) tint
{
    _nullTintLabel.text = tint;
}

-(void)setImageIcon:(NSString*)icon
{
    _nullImageView.image = [UIImage imageNamed:icon];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    CGSize size = [self labelTextSize:_nullTintLabel];
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(261/2.0) height:fitToWidth(242/2.0) toTop:(self.height-fitToWidth(242/2.0)-fitToWidth(20)-size.height)/2.0-fitToWidth(20) ];
//    if (SCREEN_WIDTH>375) {
        tmpRect.origin.x -= fitToWidth(self.xdis);
//    }else{
//        tmpRect.origin.x += 4;
//    }
    
    _nullImageView.frame = tmpRect;//CGRectMake(SCREEN_WIDTH/4.0, SCREEN_HEIGHT/4.0, SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    
    
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toTop:fitToWidth(20) + _nullImageView.bottom];
    _nullTintLabel.frame = tmpRect;
}

-(void)resetImageToCenter
{
    self.xdis = 0;
    [self layoutSubviews];
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

@end
