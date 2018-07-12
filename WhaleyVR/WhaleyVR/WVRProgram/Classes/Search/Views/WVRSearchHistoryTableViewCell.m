//
//  WVRSearchHistoryTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSearchHistoryTableViewCell.h"


@interface WVRSearchHistoryTableViewCell()

@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UILabel* keywordLabel;
@property (nonatomic, strong) UIView * bottomLine;

@end

@implementation WVRSearchHistoryTableViewCell

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
}

- (void)allocSubviews
{
    _keywordLabel = [[UILabel alloc] init];
    _clockImageView = [[UIImageView alloc] init];
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    /* Title */
    [_keywordLabel setText:@""];
    [_keywordLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_keywordLabel setFont:kFontFitForSize(15)];
    
    _clockImageView.image = [UIImage imageNamed:@"search_history"];
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_keywordLabel];
    [self.contentView addSubview:_clockImageView];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:16 height:16 toLeft:15];
    _clockImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_keywordLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:_clockImageView.right + 15];
    _keywordLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubvies];
}

- (void)updateKeyword:(NSString*) keyword;
{
    _keywordLabel.text = keyword;
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

@end
