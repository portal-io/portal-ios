//
//  WVRSearchResultsFor3DTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/26/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSearchResultsFor3DTableViewCell.h"

#import "WVRSortItemModel.h"

@interface WVRSearchResultsFor3DTableViewCell()

@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UILabel *actorLabel;
@property (nonatomic, strong) UILabel * videoTypeLabel;
@property (nonatomic, strong) UILabel * areaLabel;

@property (nonatomic, strong) UIView   *bottomLine;

@end

@implementation WVRSearchResultsFor3DTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self selfConfig];
        [self allocSubviews];
        [self configSubviews];
    }
    
    return self;
}

- (void)selfConfig
{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)allocSubviews
{
    _thumbnail = [[UIImageView alloc] init];
    _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnail.clipsToBounds = YES;
    _title = [[UILabel alloc] init];
    
    _directorLabel = [[UILabel alloc] init];
    _director = [[UILabel alloc] init];
    
    _actorLabel = [[UILabel alloc] init];
    _actor = [[UILabel alloc] init];
    
    _videoTypeLabel = [[UILabel alloc] init];
    _videoType = [[UILabel alloc] init];
    
    _areaLabel = [[UILabel alloc] init];
    _area = [[UILabel alloc] init];
    
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    /* Title */
    [_title setText:@""];
    [_title setTextColor:[UIColor blackColor]];
    [_title setFont:kFontFitForSize(15.5)];
    
    UIFont *font = kFontFitForSize(12.5);
    
    [_directorLabel setText:@"导演："];
    [_directorLabel setTextColor:[UIColor blackColor]];
    [_directorLabel setFont:font];
    
    [_director setText:@""];
    [_director setTextColor:[UIColor colorWithHex:0x898989]];
    [_director setFont:font];
    
    [_actorLabel setText:@"主演："];
    [_actorLabel setTextColor:[UIColor blackColor]];
    [_actorLabel setFont:font];
    
    [_actor setText:@""];
    [_actor setTextColor:[UIColor colorWithHex:0x898989]];
    [_actor setFont:font];
    
    [_videoTypeLabel setText:@"类型："];
    [_videoTypeLabel setTextColor:[UIColor blackColor]];
    [_videoTypeLabel setFont:font];
    
    [_videoType setText:@""];
    [_videoType setTextColor:[UIColor colorWithHex:0x898989]];
    [_videoType setFont:font];
    
    [_areaLabel setText:@"地区："];
    [_areaLabel setTextColor:[UIColor blackColor]];
    [_areaLabel setFont:font];
    
    [_area setText:@""];
    [_area setTextColor:[UIColor colorWithHex:0x898989]];
    [_area setFont:font];
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_thumbnail];
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_directorLabel];
    [self.contentView addSubview:_director];
    [self.contentView addSubview:_actorLabel];
    [self.contentView addSubview:_actor];
    [self.contentView addSubview:_videoTypeLabel];
    [self.contentView addSubview:_videoType];
    [self.contentView addSubview:_areaLabel];
    [self.contentView addSubview:_area];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    float heightLen = adaptToWidth(8);
    float widthLen = adaptToWidth(25);
    
    _thumbnail.frame = CGRectMake(adaptToWidth(15), heightLen, adaptToWidth(124), adaptToWidth(167));
    
    float width = self.width - (_thumbnail.width + adaptToWidth(25) + adaptToWidth(15) * 2);
    
    CGSize size = [self labelTextSize:_title];
    tmpRect = [self rectInSubviewWithWidth:width height:size.height toLeft:_thumbnail.right + widthLen toTop:_thumbnail.top + heightLen];
    _title.frame = tmpRect;
    
    //导演
    size = [self labelTextSize:_directorLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width height:size.height toLeft:_title.left toTop:_title.bottom + adaptToWidth(12.5)];
    _directorLabel.frame = tmpRect;
    
    width = self.width - (_directorLabel.right + adaptToWidth(15));
    
    tmpRect = [self rectInSubviewWithWidth:width height:_directorLabel.height toLeft:_directorLabel.right toTop:_directorLabel.top];
    _director.frame = tmpRect;
    
    //主演
    size = [self labelTextSize:_actorLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width height:size.height toLeft:_title.left toTop:_directorLabel.bottom + heightLen];
    _actorLabel.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:width height:_actorLabel.height toLeft:_actorLabel.right toTop:_actorLabel.top];
    _actor.frame = tmpRect;
    
    //类型
    size = [self labelTextSize:_videoTypeLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width height:size.height toLeft:_title.left toTop:_actorLabel.bottom + heightLen];
    _videoTypeLabel.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:width height:_videoTypeLabel.height toLeft:_videoTypeLabel.right toTop:_videoTypeLabel.top];
    _videoType.frame = tmpRect;
    
    //地区
    size = [self labelTextSize:_areaLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width height:size.height toLeft:_title.left toTop:_videoTypeLabel.bottom + heightLen];
    _areaLabel.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:width height:_areaLabel.height toLeft:_areaLabel.right toTop:_areaLabel.top];
    _area.frame = tmpRect;
    
    
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
}

- (void)updateUIWithModel:(WVRSortItemModel *)model
{
    [_thumbnail wvr_setImageWithURL:[NSURL URLWithUTF8String:model.image] placeholderImage:[UIImage imageNamed:@"defaulf_holder_image"]];
    
    _title.text = model.title;
    _director.text = [model.director firstObject] ?: @"";
    _actor.text = model.actor;
    _videoType.text = model.videoType;
    _area.text = model.area;
}

- (CGSize)labelTextSize:(UILabel *)label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

#pragma mark - layout

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self positionSubvies];
}

@end
