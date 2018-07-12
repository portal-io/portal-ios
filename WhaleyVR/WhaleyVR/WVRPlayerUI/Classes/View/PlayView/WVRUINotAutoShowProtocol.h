//
//  WVRUINotAutoShowProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRUINotAutoShowProtocol<NSObject>

- (BOOL)playerUINotAutoHide;
- (BOOL)playerUINotAutoShow;

/// 与其他控件隐藏状态相反
- (BOOL)playerUIHideOpposite;

@end
