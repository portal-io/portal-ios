//
//  WVRSetPresenterProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRViewPresenter.h"

@protocol WVRSetPresenter <NSObject>

-(instancetype)initWithParams:(id)params attchView:(id<WVRViewPresenter>)viewPresenter;

@optional
-(void) requestInfo:(id)requestParams;


@end
