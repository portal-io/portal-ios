//
//  WVRPassWordInputView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseInputView.h"

@protocol WVRPassWordInputViewDelegate <NSObject>

- (void)inputFinishedWithView:(UIView*) view;

@end

@interface WVRPassWordInputView : WVRBaseInputView

@property (nonatomic, weak) id<WVRPassWordInputViewDelegate> delegate;
@property (nonatomic, strong) UIView *phoneAreaCode;
@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UIView *seperateLine;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic) NSString* eventId;
@property (nonatomic) NSString* burialPoint;

- (void)updateViewStyleWithIcon:(BOOL) isIconExists andPlacehoderText:(NSString*) text;

@end
