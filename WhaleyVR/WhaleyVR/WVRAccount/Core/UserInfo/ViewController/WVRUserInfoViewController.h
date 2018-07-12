//
//  WVRUserInfoViewController.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/29/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseViewController.h"
#import "WVRBindResultModel.h"

@interface WVRUserInfoViewController : WVRBaseViewController

//@property (nonatomic, assign) BOOL QQisBinded;
//@property (nonatomic, assign) BOOL WBisBinded;
//@property (nonatomic, assign) BOOL WXisBinded;

//@property (nonatomic, strong) NSString *nickName;
//@property (nonatomic, strong) NSString *phoneNum;
//@property (nonatomic, strong) UIImage *avatar;

- (void)updateNickName:(NSString *)nickName;
- (void)requestFaild:(NSString *)errorStr;

@end
