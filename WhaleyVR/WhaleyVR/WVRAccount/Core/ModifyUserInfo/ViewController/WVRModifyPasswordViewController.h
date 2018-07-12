//
//  WVRModifyPasswordViewController.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseViewController.h"
#import "WVRModifyPasswordView.h"

@interface WVRModifyPasswordViewController : WVRBaseViewController

@property (nonatomic, assign) BOOL isFindOldPWMode;

@property (nonatomic, strong) NSString *smsCode;

@end
