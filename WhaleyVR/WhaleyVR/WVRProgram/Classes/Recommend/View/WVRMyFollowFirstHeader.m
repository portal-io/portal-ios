//
//  WVRMyFollowFirstHeader.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyFollowFirstHeader.h"

@interface WVRMyFollowFirstHeader ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainView;

@end


@implementation WVRMyFollowFirstHeader

static NSString *kMyFollowFirstCellId = @"kMyFollowFirstCellId";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createMainView];
    }
    return self;
}

- (void)createMainView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    layout.itemSize = CGSizeMake(adaptToWidth(83), self.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.showsHorizontalScrollIndicator = NO;
    
    [mainView registerClass:[WVRMyFollowHeaderCell class] forCellWithReuseIdentifier:kMyFollowFirstCellId];
    
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - setter

- (void)setDataArray:(NSArray<WVRAttentionCpList *> *)dataArray {
    
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        
        [self.mainView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.realDelegate respondsToSelector:@selector(headerDidSelectItemAtIndex:)]) {
        [self.realDelegate headerDidSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRMyFollowHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyFollowFirstCellId forIndexPath:indexPath];
    
    WVRAttentionCpList *cp = [_dataArray objectAtIndex:indexPath.item];
    
    cell.iconUrl = cp.headPic;
    cell.name = cp.name;
    
    return cell;
}

@end
