//
//  WVRConfigCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRConfigCell.h"


@implementation WVRConfigCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
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
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    
    CGRect tmpRect = CGRectZero;
    [self setFrame:tmpRect];
}

- (void)allocSubviews
{
    _titleLabel = [[UILabel alloc] init];
    _infoLabel = [[UILabel alloc] init];
    
    _goinImageView = [[UIImageView alloc] init];
    
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    /* Title */
    [_titleLabel setText:@""];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:kFontFitForSize(15)];
    
    /* Info Label */
    [_infoLabel setText:@""];
    [_infoLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_infoLabel setFont:kFontFitForSize(15)];
    
    _goinImageView.image = [UIImage imageNamed:@"find_icon_more"];
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_infoLabel];
    [self.contentView addSubview:_goinImageView];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:13/2 height:23/2 toRight:20];
    _goinImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_titleLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:20];
    _titleLabel.frame = tmpRect;
    
    size = [self labelTextSize:_infoLabel];
    if (!_goinImageView.hidden) {
        tmpRect = [self centerRectInSubviewWithWidth:MIN(200, size.width) height:size.height toRight:_goinImageView.width + 30];
    }else{
        tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toRight:20];
    }
    _infoLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubvies];
}

- (void)updateTitle:(NSString*)title
{
    _titleLabel.text = title;
}

- (void)updateInfo:(NSString*)info
{
    _infoLabel.text = info;
}

- (void)hideGoinImage
{
    _goinImageView.hidden = YES;
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

@end
