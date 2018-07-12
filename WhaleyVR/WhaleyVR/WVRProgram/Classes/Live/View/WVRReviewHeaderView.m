//
//  WVRReviewHeaderView.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRReviewHeaderView.h"
#import "WVRWidgetColorHeader.h"

@interface  WVRReviewHeaderView () {
    UILabel *_label;
    UIView  *_tagView;
}

@end


@implementation WVRReviewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = k_Color1;
        _tagView.frame = CGRectMake(0, 0, 6, 18);
        _tagView.layer.cornerRadius = 3;
        _tagView.clipsToBounds = YES;
        _tagView.centerY = self.height/2.0;
        [self addSubview:_tagView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_tagView.bottomX+fitToWidth(15.f), 0, SCREEN_WIDTH, 22)];
        _label.centerY = _tagView.centerY;
        _label.font = kFontFitForSize(12.5f);
        _label.textColor = UIColorFromRGB(0x2a2a2a);
        _label.tag = 99;
        [self addSubview:_label];
    }
    return self;
}

- (void)setTitleText:(NSString *)text {
    _label.text = text;
}

- (NSString *)titleText {
    return _label.text;
}

@end
