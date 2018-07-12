//
//  WVRAccountAvatarCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRTableViewCell.h"

#define HEIGHT_AVATARR_CELL (227.5f)

@class WVRAccountTopTableViewCell;

@protocol WVRAccountTopTableViewCellDelegate <NSObject>

- (void)buttonClickedWithTag:(NSInteger) tag;

@end


@interface WVRAccountViewAvatarCell : WVRTableViewCell

@property (nonatomic, weak) id<WVRAccountTopTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *editNickImageView;

@property (nonatomic, strong) UILabel *seperateLine;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *settingBtn;


-(void)fillData:(id)args;
@end
