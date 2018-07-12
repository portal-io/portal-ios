//
//  WVRMyFollowReuseFooter.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyFollowReuseFooter.h"

@interface WVRMyFollowReuseFooter ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *iconView;

@end


@implementation WVRMyFollowReuseFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createLabel];
        [self createBtn];
        [self createIconView];
    }
    return self;
}

- (void)createLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = k_Color1;
    label.text = @"展开更多";
    label.font = kFontFitForSize(13);
    [label sizeToFit];
    label.center = CGPointMake(self.width / 2.f - adaptToWidth(8), self.height / 2.f - adaptToWidth(3));
    
    [self addSubview:label];
    _label = label;
}

- (void)createIconView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(_label.bottomX + adaptToWidth(5), 0, adaptToWidth(12), adaptToWidth(7))];
    
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.centerY = _label.centerY;
    [self addSubview:imgV];
    
    _iconView = imgV;
}

- (void)createBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.backgroundColor = [UIColor clearColor];
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

#pragma mark - setter

- (void)setType:(FollowReuseFooterType)type {
    
    switch (type) {
        case FollowReuseFooterTypeMore: {
            _iconView.image = [UIImage imageNamed:@"my_follow_open"];
            _label.text = @"展开更多";
        }
            break;
            
        case FollowReuseFooterTypeLess: {
            _iconView.image = [UIImage imageNamed:@"my_follow_close"];
            _label.text = @"收起全部";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - action

- (void)buttonClick:(UIButton *)sender {
    
    if ([self.realDelegate respondsToSelector:@selector(footerClickAtIndex:)]) {
        [self.realDelegate footerClickAtIndex:self.tag];
    }
}

@end
