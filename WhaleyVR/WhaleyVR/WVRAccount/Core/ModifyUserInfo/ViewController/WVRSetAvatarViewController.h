//
//  WVRSetAvatarViewController.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/12/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseViewController.h"

@protocol WVRSetAvatarViewControllerDelegate <NSObject>

- (void)updateAvatar:(UIImage*) avatar;

@end


@interface WVRSetAvatarViewController : WVRBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<WVRSetAvatarViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

@end
