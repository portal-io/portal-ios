//
//  WVRCameraChangeButton.h
//  WhaleyVR
//
//  Created by Bruce on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRCameraChangeButton : UIButton

/// 标题前有小三角形
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *standType;

/// 机位类型转换为标题
+ (NSString *)standTypeToString:(NSString *)standType;

@end
