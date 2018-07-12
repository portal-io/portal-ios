//
//  WVRSQTagHorCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQTagHorCell.h"

@interface WVRSQTagHorCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *splitV;

@property (nonatomic) SQCollectionViewDelegate * collectionDelegate;
@property (nonatomic) WVRSQTagHorCellInfo * cellInfo;

@end


@implementation WVRSQTagHorCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([NSStringFromClass([self wvr_viewController].class) isEqualToString:@"WVRSpring2018TopicController"]) {
        
        self.backgroundColor = [UIColor clearColor];
        
    } else {
        
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    if (self.cellInfo == info && !info.needRefresh) {
        return;
    }
    self.cellInfo = (WVRSQTagHorCellInfo *)info;
    if (self.cellInfo.noSplitV) {
        self.splitV.hidden = YES;
    } else {
        self.splitV.hidden = NO;
    }
    [self requestInfo];
}

- (void)initCollectionView {
    
    if (!_collectionDelegate) {
        _collectionDelegate = [SQCollectionViewDelegate new];
        _collectionView.delegate = _collectionDelegate;
        _collectionView.dataSource = _collectionDelegate;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
}

- (void)requestInfo {
    
    for (NSString* cur in self.cellInfo.headerNibNames) {
        [_collectionView registerNib:[UINib nibWithNibName:cur bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cur];
    }
    for (NSString* cur in self.cellInfo.cellNibNames) {
        [_collectionView registerNib:[UINib nibWithNibName:cur bundle:nil] forCellWithReuseIdentifier:cur];
    }
    for (NSString * cur in self.cellInfo.cellClassNames) {
        [_collectionView registerClass:NSClassFromString(cur) forCellWithReuseIdentifier:cur];
    }
    
    [self.collectionDelegate loadData:self.cellInfo.originDic];
    [_collectionView reloadData];
}

- (SQCollectionViewSectionInfo *)getDefaultSectionInfo {
    
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    return sectionInfo;
}

@end


@implementation WVRSQTagHorCellInfo

@end
