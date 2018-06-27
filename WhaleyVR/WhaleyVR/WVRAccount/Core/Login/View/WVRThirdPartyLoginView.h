//
//  WVRThirdPartyLoginView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVRThirdPartyLoginView;

@protocol WVRThirdPartyLoginViewDelegate <NSObject>

- (void)bindView:(WVRThirdPartyLoginView *)view buttonClickedAtIndex:(NSInteger)index;

@end

@interface WVRThirdPartyLoginView : UIView

@property (nonatomic, weak) id<WVRThirdPartyLoginViewDelegate>delegate;

- (void)setTintText:(NSString*) text;
- (void)setBottomTintLabelHidden;

- (void)updateStatusOfQQIcon:(BOOL) QQisBinded WBIcon:(BOOL) WBisBinded WXIcon:(BOOL) WXisBinded;

@end
