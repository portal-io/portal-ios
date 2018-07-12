//
//  WVRLoginViewController.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/24/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseUserController.h"
#import "WVRLoginView.h"
#import "WVRNavigationController.h"

@interface WVRLoginViewController : WVRBaseUserController

@property (nonatomic, assign) WVRLoginViewViewStyle viewStyle;

- (void)requestFaild:(NSString *)errorStr;

-(void)thirtyPClick:(NSInteger)type;

-(void)configSelf;

-(void)configSubviews;

-(void)initLoginRAC;

@end
