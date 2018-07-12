//
//  WVRDeleteFooterView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT_DELETE_FOOTVIEW (fitToWidth(50.f))

@interface WVRDeleteFooterView : UIView

@property (nonatomic, copy) void(^selectAllBlock)(BOOL);
@property (nonatomic, copy) void(^delBlock)(void);

- (void)resetStatus;
- (void)updateDelTitle:(NSString *)title;
- (void)updateSelectStatus:(BOOL)allSelect;

@end
