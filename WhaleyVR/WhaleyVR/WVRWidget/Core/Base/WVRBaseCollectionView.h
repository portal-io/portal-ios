//
//  WVRBaseCollectionView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionView.h"


#import "WVRListViewProtocol.h"

@interface WVRBaseCollectionView : UICollectionView <WVRListViewProtocol>

#pragma mark - errorView and nullView

- (void)showNullViewTitle:(NSString *)title icon:(NSString *)icon;

- (void)removeNullView;

- (void)removeNetErrorV;

@end
