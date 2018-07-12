//
//  WVRShowFieldView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRShowFieldView : UIView

@property (nonatomic, readonly) BOOL isLoaded;

// 创建
+ (instancetype)createWithFrame:(CGRect)frame info:(NSDictionary *)info;

- (void)updateFrame:(CGRect)frame;

// 刷新界面
- (void)refreshData;

@end
