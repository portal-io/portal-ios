//
//  WVRLiveRecBannerItemView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecBannerItemView.h"

@implementation WVRLiveRecBannerItemView

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    NSArray* subviews = self.subviews;
    for (UIView * view in subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            //            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = fitToWidth(constraint.constant);
        }
    }
//    [self addSubview:self.mainImageView];
//    [self addSubview:self.coverView];
//    _mainImageView.layer.cornerRadius = 4;
//    _mainImageView.layer.masksToBounds = YES;
    _mainImageView.userInteractionEnabled = YES;
}

-(void)layoutSubviews
{
    for (UIView* view in _mainImageView.subviews) {
        view.bounds = _mainImageView.bounds;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

//- (UIImageView *)mainImageView {
//    
//    if (_mainImageView == nil) {
//        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _mainImageView.clipsToBounds = YES;
//        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _mainImageView.height = fitToWidth(189.f);
//        _mainImageView.userInteractionEnabled = YES;
//    }
//    return _mainImageView;
//}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}


@end
