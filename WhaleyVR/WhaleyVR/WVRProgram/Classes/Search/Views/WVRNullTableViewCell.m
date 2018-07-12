//
//  WVRNullTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/26/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRNullTableViewCell.h"


@interface WVRNullTableViewCell()

@property (nonatomic, strong) UIImageView *nullImageView;
@property (nonatomic, strong) UILabel     *nullTintLabel;

@end

@implementation WVRNullTableViewCell

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
    [_nullTintLabel setText:@"抱歉，未找到相关视频"];
    [_nullTintLabel setTextColor:[UIColor colorWithHex:0xd3d3d3]];
    [_nullTintLabel setFont:kFontFitForSize(30/2)];
    
    _nullImageView.image = [UIImage imageNamed:@"search_null"];
    
    [self.contentView addSubview:_nullImageView];
    [self.contentView addSubview:_nullTintLabel];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:272/2 height:283/2 toTop:110];
    _nullImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_nullTintLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toTop:35 + _nullImageView.bottom];
    _nullTintLabel.frame = tmpRect;
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
