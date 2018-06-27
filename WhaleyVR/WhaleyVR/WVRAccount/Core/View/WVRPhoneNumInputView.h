//
//  WVRPhoneNumInputView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/24/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseInputView.h"

@protocol WVRPhoneNumInputViewDelegate <NSObject>

- (void)inputFinishedWithView:(UIView *) view;
- (void)textFieldChangedText:(NSString *) text;

@end


@interface WVRPhoneNumInputView : WVRBaseInputView

@property (nonatomic, weak) id<WVRPhoneNumInputViewDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic) NSString* eventId;
@property (nonatomic) NSString* burialPoint;

- (void)updateViewStyleWithIcon:(BOOL) isIconExists andPlacehoderText:(NSString*) text;

@end
