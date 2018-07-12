//
//  WVRBasePagePresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRBaseSubPagePresenterProtocol.h"
#import "WVRCollectionViewProtocol.h"
#import "SQCollectionViewDelegate.h"
#import "WVRPresenter.h"
#import "WVRViewModelDispatcher.h"

@class WVRBaseViewSection,WVRSectionModel;

@interface WVRBaseSubPagePresenter : WVRPresenter <WVRBaseSubPagePresenterProtocol>

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString * className;

@property (nonatomic, strong) id args;

@property (nonatomic, strong) SQCollectionViewDelegate * collectionViewDelegte;

@property (nonatomic, weak) UICollectionView * collectionView;

@property (nonatomic, weak) id<WVRCollectionViewProtocol> gView;

-(WVRBaseViewSection*)sectionInfo:(WVRSectionModel*)sectionModel;

- (void)networkFaild ;
@end
