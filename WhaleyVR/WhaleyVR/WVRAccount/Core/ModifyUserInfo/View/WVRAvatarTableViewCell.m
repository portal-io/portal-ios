//
//  WVRAvatarTableViewCell.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRAvatarTableViewCell.h"


@interface WVRAvatarTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation WVRAvatarTableViewCell

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
    _avatarImageView = [[UIImageView alloc] init];
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews
{
    /* Title */
    [_titleLabel setText:@""];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:kFontFitForSize(15)];
    
    _avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
    _avatarImageView.layer.cornerRadius = 55/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_avatarImageView];
    [self.contentView addSubview:_bottomLine];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:55 height:55 toRight:20];
    _avatarImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_titleLabel];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toLeft:20];
    _titleLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:SCREEN_WIDTH height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubvies];
}

- (void)updateTitle:(NSString*) title
{
    _titleLabel.text = title;
}

- (void)updateAvatar {
    _avatarImageView.image = [WVRUserModel sharedInstance].tmpAvatar;
//    [_avatarImageView wvr_setImageWithURL:[NSURL URLWithString:[WVRUserModel sharedInstance].loginAvatar] placeholderImage:HOLDER_HEAD_IMAGE];
}

- (CGSize)labelTextSize:(UILabel *)label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x - 10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
