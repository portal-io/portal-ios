//
//  WVRModifyNickNameView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/31/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WVRPhoneNumInputView.h"

@interface WVRModifyNickNameView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *tintLabel;

- (NSString *)getNewNickName;
- (void)updateNickName:(NSString *)nick;

@end
