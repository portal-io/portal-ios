//
//  WVRUIEngine.h
//  VRManager
//
//  Created by Snailvr on 16/7/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRUIEngine : NSObject

+ (UIImage *)videoDetailNavImage;

+ (UIImage *)bannerTitleImage;

// desc Label attributed String
+ (NSAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

/// 详情页的描述
+ (NSAttributedString *)descStringWithString:(NSString *)string;

@end
