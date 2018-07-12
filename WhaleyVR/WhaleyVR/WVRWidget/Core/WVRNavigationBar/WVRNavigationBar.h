//
//  WVRNavigationBar.h
//  WhaleyVR
//
//  Created by Bruce on 2017/2/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRNavigationBar : UINavigationBar

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 0~1
- (void)setOverlayDiaphaneity:(float)alpha;

@end


/// 详情页使用的半透明导航栏
@interface WVRDetailNavigationBar : WVRNavigationBar

@end
