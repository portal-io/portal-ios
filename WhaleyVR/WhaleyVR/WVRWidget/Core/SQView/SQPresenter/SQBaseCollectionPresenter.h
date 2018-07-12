//
//  SQBaseCollectionPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBasePresenter.h"
#import "SQCollectionView.h"
#import "WVRNullCollectionViewCell.h"
#import "SQCollectionViewDelegate.h"

@interface SQBaseCollectionPresenter : SQBasePresenter

@property (nonatomic,weak) UIViewController * controller;

@property (nonatomic) SQCollectionView * mCollectionV;

@property (nonatomic) SQCollectionViewDelegate * collectionDelegate;

@property (nonatomic) NSMutableDictionary * collectionVOriginDic;

@property (nonatomic) NSArray * cellNibNames;

@property (nonatomic) NSArray * cellClassNames;

@property (nonatomic) NSArray * headerNibNames;

@property (nonatomic) NSArray * headerClassNames;

@property (nonatomic) NSArray * footerNibNames;

@property (nonatomic) NSArray * footerClassNames;

@property (nonatomic) id createArgs;

@property (nonatomic) WVRNullCollectionViewCell * mNullView;

- (void)requestInfo NS_REQUIRES_SUPER;
- (void)initCollectionView NS_REQUIRES_SUPER;

@end
