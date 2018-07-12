//
//  WVRMineSuspendView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/12/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MineSuspendButtonType) {
    
    MineSuspendButtonTypeCoin,          // 鲸币
    MineSuspendButtonTypeTicket,        // 券
    MineSuspendButtonTypeReward,        // 礼物
};

@interface WVRMineSuspendView : UIView

@property (nonatomic, copy) void(^btnClickBlock)(MineSuspendButtonType type);

@end


@interface WVRMineSuspendButton : UIButton

- (instancetype)initWithImageName:(NSString *)imgName title:(NSString *)title;

@end
