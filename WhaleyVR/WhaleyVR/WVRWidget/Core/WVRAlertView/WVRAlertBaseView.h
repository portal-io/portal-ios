//
//  WVRAlertBaseView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/27/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRAlertBaseView : UIView

@property (nonatomic) BOOL enableBgTouchDisappear;

@property (nonatomic, strong) UIView *glassBoard;
@property (nonatomic, strong) UIView *baseBoard;

- (void)showOnView:(UIView *)parentView;
- (void)disappearHandle;
- (void)disappearCompleteCallback;

@end
