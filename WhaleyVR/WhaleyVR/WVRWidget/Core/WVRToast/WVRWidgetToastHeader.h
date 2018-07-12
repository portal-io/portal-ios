//
//  WVRWidgetToastHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRWidgetToastHeader_h
#define WVRWidgetToastHeader_h

#import "SQToastTool.h"
#import "UIView+Extend.h"
#import "UIViewController+HUD.h"

#define SQToast(TEXT) ([SQToastTool showMessageCenter:self.view.window withMessage:TEXT])
#define SQToastTOP(TEXT) ([SQToastTool showMessageTop:self.view.window withMessage:TEXT])

#define SQToastBottom(TEXT) ([SQToastTool showMessage:self.view.window withMessage:TEXT])
#define SQToastIn(TEXT, VIEW) ([SQToastTool showMessageCenter:VIEW.window withMessage:TEXT])
#define SQToastTOPIn(TEXT, VIEW) ([SQToastTool showMessageTop:VIEW.window withMessage:TEXT])
#define SQToastBottomIn(TEXT, VIEW) ([SQToastTool showMessage:VIEW.window withMessage:TEXT])
#define SQUP_Window ([[[UIApplication sharedApplication] windows] firstObject])
#define SQToastInKeyWindow(TEXT) ([SQToastTool showMessageToWindowCenter:TEXT])
#define SQToastBottomInKeyWindow(TEXT) ([SQToastTool showMessageToWindow:TEXT])

#define SQShowProgress ([self showProgress]);

#define SQShowProgressIn(P) ([P showProgress]);
#define SQHideProgressIn(P) ([P hideProgress]);

#define SQHideProgress ([self hideProgress]);

#define WVRToastInKeyWindow(TEXT) ([SQToastTool showToastWithMsg:TEXT inKeyWindowWithyScale:0.4]);

#endif /* WVRWidgetToastHeader_h */
