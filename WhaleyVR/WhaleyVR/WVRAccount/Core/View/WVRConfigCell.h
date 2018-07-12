//
//  WVRConfigCell.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRConfigCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIImageView *goinImageView;

@property (nonatomic, strong) UIView *bottomLine;

- (void)updateTitle:(NSString*)title;
- (void)updateInfo:(NSString*)info;

- (void)hideGoinImage;

@end
