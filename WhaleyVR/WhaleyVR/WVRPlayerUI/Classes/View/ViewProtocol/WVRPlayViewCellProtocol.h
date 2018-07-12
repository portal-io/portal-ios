//
//  WVRPlayViewCellProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerViewHeader.h"
@class WVRPlayViewCellViewModel;

@protocol WVRPlayViewCellProtocol <NSObject>

- (void)fillData:(WVRPlayViewCellViewModel *)args;

- (void)installRAC;

- (void)createLayouts;

- (void)updateLockStatus:(WVRPlayerToolVStatus)status;

- (void)updateStatus:(WVRPlayerToolVStatus)status;

- (void)updatePayStatus:(WVRPlayerToolVStatus)status;

-(void)updateHidenStatus:(BOOL)isHiden;

-(void)enableWatingPayStatus;

-(void)enablePaySuccessStatus;
@end
