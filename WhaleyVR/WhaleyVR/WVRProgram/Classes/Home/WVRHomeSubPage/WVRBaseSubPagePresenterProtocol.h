//
//  WVRBaseSubPagePresenterProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenterProtocol.h"

@protocol WVRBaseSubPagePresenterProtocol <WVRPresenterProtocol>

-(void) requestInfo:(id)requestParams;

-(void)requestInfoForFirst:(id)requestParams;

-(void) headerRefreshRequestInfo:(id)requestParams;

-(void) footerMoreRequestInfo:(id)requestParams;

-(void)reloadPlayer;

@end
