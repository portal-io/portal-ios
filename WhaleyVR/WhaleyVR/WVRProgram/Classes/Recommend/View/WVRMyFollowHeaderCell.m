//
//  WVRMyFollowHeaderCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyFollowHeaderCell.h"

@interface WVRMyFollowHeaderCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *iconView;

@end


@implementation WVRMyFollowHeaderCell

// height: 210     width:180
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createIconView];
        [self createNameLabel];
    }
    return self;
}

- (void)createIconView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(20), adaptToWidth(15), adaptToWidth(50), adaptToWidth(50))];
    
    imgV.clipsToBounds = YES;
    imgV.layer.cornerRadius = imgV.height / 2.f;
    imgV.layer.borderWidth = fitToWidth(0.6);
    imgV.layer.borderColor = k_Color9.CGColor;
    imgV.userInteractionEnabled = YES;
    
    [self addSubview:imgV];
    _iconView = imgV;
}

- (void)createNameLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottomY + adaptToWidth(5), self.width, adaptToWidth(25))];
    
    label.font = kFontFitForSize(12);
    label.textColor = k_Color4;
    label.textAlignment = NSTextAlignmentCenter;
    label.centerX = _iconView.centerX;
    
    [self addSubview:label];
    _nameLabel = label;
}

#pragma mark - setter

- (void)setName:(NSString *)name {
    
    self.nameLabel.text = name;
}

- (void)setIconUrl:(NSString *)iconUrl {
    
    [self.iconView wvr_setImageWithURL:[NSURL URLWithUTF8String:iconUrl] placeholderImage:[UIImage imageNamed:@"default_publisher_icon"]];
}

@end
