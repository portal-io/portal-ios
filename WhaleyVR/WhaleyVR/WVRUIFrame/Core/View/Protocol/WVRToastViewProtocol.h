//
//  WVRToastView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRToastViewProtocol <NSObject>

@required
- (void)showToast:(NSString*)content;

@optional
-(void)showAlert;
@end
