//
//  WVRSetTableViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRViewPresenter <NSObject>

@required

-(void)showLoading;

-(void)hidenLoading;

-(void)updateViewWith:(id)info;

-(void)reloadData;

-(void) showErrorRequestView:(NSError*)error;

-(void) showNullRequestView;

-(void) clearErrorView;

-(void) clearNullView;

-(UIViewController*)curOwnerController;

@end
