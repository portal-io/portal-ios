//
//  WVRScoreLabel.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRScoreLabel.h"


@implementation WVRScoreLabel


- (instancetype)initWithScore:(float)score {
    
    self = [super init];
    
    if (self) {
        
        _score = score;
        [self createSubViewsWithScore:score];
    }
    
    return self;
}

- (void)setScore:(float)score {
    
    if (_score != score) {
        
        _score = score;
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        [self createSubViewsWithScore:score];
    }
}

- (void)createSubViewsWithScore:(float)score {
    
    float width = 130;
    float height = 25;
    self.size = CGSizeMake(width, height);
    
    UIImage *full = [UIImage imageNamed:@"icon_movie_score"];
    UIImage *half = [UIImage imageNamed:@"icon_movie_score_half"];
    UIImage *none = [UIImage imageNamed:@"icon_movie_score_none"];
    
    UIImage *image;
    
    float length = 5;
    
    for (int i = 0; i < 5; i ++) {
        
        if (score >= i * 2 + 1) {
            image = full;
        } else if (score > i * 2) {
            image = half;
        } else {
            image = none;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.centerY = self.height/2.0;
        imageView.x = (imageView.width + length) * i;
        
        [self addSubview:imageView];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%.1f分", score];
    label.textColor = [UIColor colorWithHex:0x898989];
    label.font = [UIFont systemFontOfSize:13];
    [label sizeToFit];
    label.centerY = self.height/2.0;
    label.x = 95;
    
    [self addSubview:label];
}

@end
