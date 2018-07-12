//
//  WVRSetAvatarView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/12/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSetAvatarView.h"


@implementation WVRSetAvatarView

- (id)init
{
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)dealloc
{
}

- (void)configSelf
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)allocSubviews
{
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.backgroundColor = [UIColor blackColor];
}

- (void)configSubviews
{
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_avatarImageView];
}

- (void)positionSubviews
{
    CGRect tmpRect = CGRectZero;
    
    _avatarImageView.size = self.size;
    tmpRect = [self centerRectInSubviewWithView:_avatarImageView];
    _avatarImageView.frame = tmpRect;
    
}

- (void)layoutSubviews
{
    [self positionSubviews];
}

- (void)updateAvatar:(UIImage *)avatar
{
    [_avatarImageView setImage:avatar];
    
    [self positionSubviews];
}

//#pragma mark - MISC
//- (UIGestureRecognizer *)tapGesture
//{
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
//    return tapGesture;
//}


@end
