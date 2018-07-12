//
//  WVRCameraChangeButton.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCameraChangeButton.h"
#import <SDWebImage/SDWebImage.h>
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"
#import "UIButton+Extends.h"
#import "WVRComputeTool.h"

@implementation WVRCameraChangeButton {
    
    UIImageView *_icon;
}

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, 0, adaptToWidth(60), adaptToWidth(30))];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.height * 0.5;
        self.layer.masksToBounds = YES;
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = fitToWidth(2);
        
        [self setBackgroundImageWithColor:k_Color3 forState:UIControlStateNormal];
        [self setBackgroundImageWithColor:k_Color2 forState:UIControlStateHighlighted];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:kFontFitForSize(16)];
        
        [self createSelectIcon];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    NSString *realTitle = [WVRCameraChangeButton standTypeToString:title];
    
    [super setTitle:realTitle forState:state];
    
    float width = [WVRComputeTool sizeOfString:realTitle Size:CGSizeMake(800, 800) Font:self.titleLabel.font].width;
    
    self.width = width + fitToWidth(18) * 2;
}

- (void)createSelectIcon {
    
    float gap = fitToWidth(8);
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 0, gap, gap)];
    
    imgV.image = [UIImage imageNamed:@"current_camera_stand"];
    imgV.centerY = self.height * 0.5;
    imgV.hidden = YES;
    
    [self addSubview:imgV];
    _icon = imgV;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    _icon.hidden = !isSelect;
}

//"SlideCamera";//vr足球源（电兔）
//"Spidercam";//vr足球源（飞猫）
//"ArmRight";//vr足球源（vip右摇臂）
//"ArmLeft";//vr足球源（vip左摇臂）
//"AlternativeRight";//vr足球源（右替补席）
//"AlternativeLeft";//vr足球源（左替补席）
//"Studio";//vr足球源（演播室）
//"Public";//vr足球源（公共信号）

//20170731、机位命名修改：
//1）公共信号：主视角
//2）飞猫：上帝视角
//3）左摇臂：左球门
//4）右摇臂：右球门
//5）电兔：边裁视角

+ (NSString *)standTypeToString:(NSString *)standType {
    
    if ([standType isEqualToString:@"Public"]) {
        return @"主视角";
    }
    if ([standType isEqualToString:@"SlideCamera"]) {
        return @"边裁视角";
    }
    if ([standType isEqualToString:@"Spidercam"]) {
        return @"上帝视角";
    }
    if ([standType isEqualToString:@"ArmRight"]) {
        return @"右球门";
    }
    if ([standType isEqualToString:@"ArmLeft"]) {
        return @"左球门";
    }
    if ([standType isEqualToString:@"AlternativeRight"]) {
        return @"右替补席";
    }
    if ([standType isEqualToString:@"AlternativeLeft"]) {
        return @"左替补席";
    }
    if ([standType isEqualToString:@"Studio"]) {
        return @"演播室";
    }
    DDLogError(@"standTypeToString error 未约定的类型");
    return standType;
}

@end
