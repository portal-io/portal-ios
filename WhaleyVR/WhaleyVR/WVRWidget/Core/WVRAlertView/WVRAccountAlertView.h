//
//  WVRAccountAlertView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/27/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRAlertBaseView.h"

@class WVRAccountAlertView;
@protocol WVRAccountAlertViewDelegate <NSObject>

- (void)ensureView:(WVRAccountAlertView *)ensureView buttonDidClickedAtIndex:(NSInteger)index;

@end


@interface WVRAccountAlertView : WVRAlertBaseView

@property (nonatomic, weak) id<WVRAccountAlertViewDelegate>delegate;

- (void)setTitle:(NSString *)title;

@end
