//
//  SQEmbedCollectionCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQEmbedHorCollectionCell.h"
#import "WVRAppContextHeader.h"

@interface SQEmbedHorCollectionCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) SQCollectionViewDelegate * collectionDelegate;
@property (nonatomic) SQEmbedHorCollectionCellInfo * cellInfo;

@end


@implementation SQEmbedHorCollectionCell

//- (instancetype)init
//{
//    self = [super init];
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        [self setup];
////        [self initCollectionView];
//    }
//    return self;
//}


//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        //        VIEW_WITH_NIB([WVRSQDownView description]);
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup
//{
//    [[NSBundle mainBundle] loadNibNamed:@"SQEmbedHorCollectionCell" owner:self options:nil];
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
//    self.frame = self.view.frame;
//    [self addSubview:self.view];
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initCollectionView];
}

- (void)initCollectionView
{
    if (!_collectionDelegate) {
        _collectionDelegate = [SQCollectionViewDelegate new];
        _collectionView.delegate = _collectionDelegate;
        _collectionView.dataSource = _collectionDelegate;
        _collectionView.scrollEnabled = YES;
    }
}


- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    if (self.cellInfo==info) {
        return;
    }
    kWeakSelf(self);
    self.cellInfo = (SQEmbedHorCollectionCellInfo*)info;
    self.collectionDelegate.scrollBottomBlock = ^(BOOL isBottom){
        
        if (weakself.cellInfo.scrollBottomBlock) {
            weakself.cellInfo.scrollBottomBlock();
        }
    };
    [self requestInfo];
}

- (void)requestInfo
{
    for (NSString* cur in self.cellInfo.cellNibNames) {
        [_collectionView registerNib:[UINib nibWithNibName:cur bundle:nil] forCellWithReuseIdentifier:cur];
    }
    for (NSString * cur in self.cellInfo.cellClassNames) {
        [_collectionView registerClass:NSClassFromString(cur) forCellWithReuseIdentifier:cur];
    }
    [self.collectionDelegate loadData:self.cellInfo.originDic];
    [_collectionView reloadData];
}

- (SQCollectionViewSectionInfo*)getDefaultSectionInfo
{
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    return sectionInfo;
}

@end


@implementation SQEmbedHorCollectionCellInfo

@end
