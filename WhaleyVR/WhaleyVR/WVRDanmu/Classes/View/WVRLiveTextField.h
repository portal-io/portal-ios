//
//  WVRLiveTextField.h
//  WVRDanmu
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN_RIGHT (fitToWidth(10))
#define MARGIN_BETWEEN_VRMODE_DEFINE (fitToWidth(20))
#define MAX_LENGTH_SEND_TEXT (fitToWidth(40) + MARGIN_BOTTOM_TEXTFILED + MARGIN_TOP_TEXTFILED)

@protocol WVRLiveTextFieldDelegate<NSObject>

- (void)textFieldWillReturn:(NSString *)text;

@end


@interface WVRLiveTextField : UITextField

@property (nonatomic, weak) id<WVRLiveTextFieldDelegate> realDelegate;

@end
