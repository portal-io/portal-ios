//
//  WVRClearTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/26/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRClearTableViewCell.h"


@interface WVRClearTableViewCell()

@property (nonatomic, strong) UIImageView *clearImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *clearLabel;
@property (nonatomic, strong) UIView      *bottomLine;

@end

@implementation WVRClearTableViewCell

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
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)allocSubviews
{
    _titleLabel = [[UILabel alloc] init];
    _clearImageView = [[UIImageView alloc] init];
    _clearLabel = [[UILabel alloc] init];
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    /* Title */
    [_titleLabel setText:@"搜索历史"];
    [_titleLabel setTextColor:[UIColor colorWithHex:0xd3d3d3]];
    [_titleLabel setFont:kFontFitForSize(27/2)];
    
    [_clearLabel setText:@"清空"];
    [_clearLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_clearLabel setFont:kFontFitForSize(27/2)];
    _clearLabel.userInteractionEnabled = YES;
    [_clearLabel addGestureRecognizer:[self tapGesture]];
    
    _clearImageView.image = [UIImage imageNamed:@"clear"];
    _clearImageView.userInteractionEnabled = YES;
    [_clearImageView addGestureRecognizer:[self tapGesture]];
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_clearLabel];
    [self.contentView addSubview:_clearImageView];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    CGSize size = [self labelTextSize:_titleLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:15];
    _titleLabel.frame = tmpRect;
    
    size = [self labelTextSize:_clearLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toRight:15];
    _clearLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:11 height:25/2 toRight:45/2 + _clearLabel.width];
    _clearImageView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
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

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    UIView *tmpView = gesture.view;
    
    if (tmpView == _clearImageView || tmpView == _clearLabel) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clearHistoryKeyword)]) {
            [self.delegate clearHistoryKeyword];
        }
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

@end
