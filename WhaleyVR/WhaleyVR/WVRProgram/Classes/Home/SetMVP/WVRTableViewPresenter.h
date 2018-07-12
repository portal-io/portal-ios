//
//  WVRTableViewPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRTableViewPresenter <NSObject>


-(void)beginRefreshHeader;

-(void)beginRefreshFootMore;

-(void)endRefreshing;

-(void)endRefreshingWithNoMoreData;


@end
