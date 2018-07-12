//
//  WVRSetAvatarView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/12/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRSetAvatarView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;

- (void)updateAvatar:(UIImage*) avatar;

@end
