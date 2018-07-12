//
//  WVRCollectionViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRListViewProtocol.h"
#import "WVRLoadingViewProtocol.h"

@class UICollectionView;

@protocol UICollectionViewDelegate, UICollectionViewDataSource;

@protocol WVRCollectionViewProtocol <WVRListViewProtocol, WVRLoadingViewProtocol>

-(void)requestInfo;

-(void)detailLoadFail:(id)args;

-(void)subHandleFail:(NSString*)toast;


@optional

- (void) setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource;


-(UICollectionView*)getCollectionView;
@end
