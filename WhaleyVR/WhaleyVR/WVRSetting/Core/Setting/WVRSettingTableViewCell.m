//
//  WVRSettingTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/14/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSettingTableViewCell.h"
#import "WVRUserModel.h"

@interface WVRSettingTableViewCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *goinImageView;
@property (nonatomic, strong) UISwitch *swith;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation WVRSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    [self setBackgroundColor:[UIColor whiteColor]];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect tmpRect = CGRectZero;
    [self setFrame:tmpRect];
}

- (void)allocSubviews
{
    _leftLabel = [[UILabel alloc] init];
    _rightLabel = [[UILabel alloc] init];
    _goinImageView = [[UIImageView alloc] init];
    
    _swith = [[UISwitch alloc] init];
    _segment = [[UISegmentedControl alloc] initWithItems:@[ @"高清", @"超清" ]];
    
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    [_leftLabel setText:@""];
    [_leftLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_leftLabel setFont:kFontFitForSize(15)];
    
    [_rightLabel setText:@""];
    [_rightLabel setTextColor:[UIColor colorWithHex:0x898989]];
    [_rightLabel setFont:kFontFitForSize(15)];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    
    _goinImageView.image = [UIImage imageNamed:@"find_icon_more"];
    
    _swith.on = (![WVRUserModel sharedInstance].isOnlyWifi) ? YES:NO;
    [_swith addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _segment.selectedSegmentIndex = [WVRUserModel sharedInstance].defaultDefinition;
    [_segment addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged]; //添加事件
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_leftLabel];
    [self.contentView addSubview:_rightLabel];
    [self.contentView addSubview:_goinImageView];
    [self.contentView addSubview:_swith];
    [self.contentView addSubview:_segment];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    CGSize size = [self labelTextSize:_leftLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:15];
    _leftLabel.frame = tmpRect;
    
    size = [self labelTextSize:_rightLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toRight:15];
    _rightLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:13/2 height:23/2 toRight:15];
    _goinImageView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:_swith.width height:_swith.height toRight:15];
    _swith.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:375/2 height:55/2 toRight:15];
    _segment.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:self.width height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self positionSubvies];
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (void)updateLeftLabel:(NSString*) left
{
    _leftLabel.text = left;
}

- (void)updateRightLabel:(NSString*) right
{
    _rightLabel.text = right;
    CGSize size = [self labelTextSize:_rightLabel];
    CGRect tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toRight:15];
    _rightLabel.frame = tmpRect;
}

- (void)updateWithViewStyle:(WVRSettingTableViewCellStyle)style
{
    switch (style) {
        case WVRSettingTableViewCellNull:
        {
            _goinImageView.hidden = YES;
            _swith.hidden = YES;
            _segment.hidden = YES;
        }
            break;
        case WVRSettingTableViewCellGoin:
        {
            _swith.hidden = YES;
            _segment.hidden = YES;
        }
            break;
        case WVRSettingTableViewCellSwith:
        {
            _goinImageView.hidden = YES;
            _segment.hidden = YES;
        }
            break;
        case WVRSettingTableViewCellSegment:
        {
            _goinImageView.hidden = YES;
            _swith.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)switchAction:(UISwitch *)sender
{
    BOOL isSwitchOn = [sender isOn];
    
    [[WVRUserModel sharedInstance] setOnlyWifi:!isSwitchOn];
}

- (void)segmentedAction:(UISegmentedControl *)sender {
    
    [[WVRUserModel sharedInstance] setDefaultDefinition:sender.selectedSegmentIndex];
}

@end
