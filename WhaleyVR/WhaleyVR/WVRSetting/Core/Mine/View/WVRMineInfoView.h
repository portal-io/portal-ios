//
//  WVRMineInfoView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/12/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRMineInfoView : UIView

/// 使用 initWithFrame:
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, copy) void(^infoClickBlock)(void);

@property (nonatomic, copy) void(^loginClickBlock)(void);

@property (nonatomic, copy) void(^registerClickBlock)(void);

@end
