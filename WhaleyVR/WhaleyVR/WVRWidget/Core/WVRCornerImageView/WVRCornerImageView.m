//
//  WVRCornerImageView.m
//  VRManager
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRCornerImageView.h"
#import "Masonry.h"

@implementation WVRCornerImageView


- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
        UIImage *image = [UIImage imageNamed:@"imageView_corner_8"]; // 圆角半径为4，可以更改渲染模式/前景色
        
        CGFloat top = image.size.height * 0.5;
        CGFloat left = image.size.width * 0.5;
        CGFloat bottom = image.size.height * 0.5;
        CGFloat right = image.size.width * 0.5;
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImageResizingMode mode = UIImageResizingModeStretch;
        
        UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];

        imageView.image = newImage;
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.size.equalTo(self);
        }];
    }
    
    return self;
}

@end
