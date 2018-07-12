//
//  SQBaseCollectionPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseCollectionPresenter.h"

@implementation SQBaseCollectionPresenter

- (void)initCollectionView {
    
    
    [self registerNib];
    [self registerClass];
    self.mCollectionV.backgroundColor = [UIColor redColor];//UIColorFromRGB(0xeeeeee);
    if (!self.collectionVOriginDic) {
        self.collectionVOriginDic = [NSMutableDictionary new];
    }
    if (!self.collectionDelegate) {
        self.collectionDelegate = [[SQCollectionViewDelegate alloc]init];
        self.mCollectionV.dataSource = self.collectionDelegate;
        self.mCollectionV.delegate = self.collectionDelegate;
    }
}

-(SQCollectionView *)mCollectionV
{
    if (!_mCollectionV) {
        _mCollectionV = [[SQCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    return _mCollectionV;
}

- (void)registerNib {
    
    for (NSString* cur in self.headerNibNames) {
        [self.mCollectionV registerNib:[UINib nibWithNibName:cur bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cur];
    }
    
    for (NSString* cur in self.footerNibNames) {
        [self.mCollectionV registerNib:[UINib nibWithNibName:cur bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cur];
    }
    
    for (NSString* cur in self.cellNibNames) {
        [self.mCollectionV registerNib:[UINib nibWithNibName:cur bundle:nil] forCellWithReuseIdentifier:cur];
    }
}

- (void)registerClass {
    
    for (NSString * cur in self.headerClassNames) {
        [self.mCollectionV registerClass:NSClassFromString(cur) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cur];
    }
    
    for (NSString * cur in self.footerClassNames) {
        [self.mCollectionV registerClass:NSClassFromString(cur) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cur];
    }
    for (NSString * cur in self.cellClassNames) {
        [self.mCollectionV registerClass:NSClassFromString(cur) forCellWithReuseIdentifier:cur];
    }
}

- (void)requestInfo {
    
}

- (void)dealloc {
    
//    DebugLog(@"");
    [_collectionVOriginDic removeAllObjects];
    _collectionVOriginDic = nil;
    _collectionDelegate = nil;
    [_mCollectionV removeFromSuperview];
    _mCollectionV = nil;
}

@end
