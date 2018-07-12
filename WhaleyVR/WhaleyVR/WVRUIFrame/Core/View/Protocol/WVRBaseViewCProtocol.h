//
//  WVRBaseCView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRToastViewProtocol.h"
#import "WVREmptyViewProtocol.h"
#import "WVRLoadingViewProtocol.h"
#import "WVRViewProtocol.h"

@protocol WVRBaseViewCProtocol <WVRToastViewProtocol, WVREmptyViewProtocol, WVRLoadingViewProtocol, WVRViewProtocol>

-(UIView<WVREmptyViewProtocol>*)getEmptyView;

-(void)requestInfo;

-(void)detailLoadFail:(id)args;

-(void)subHandleFail:(NSString*)toast;

@end
