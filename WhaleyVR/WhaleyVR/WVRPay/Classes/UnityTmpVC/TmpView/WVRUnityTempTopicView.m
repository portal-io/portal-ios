//
//  WVRUnityTempTopicView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityTempTopicView.h"
//#import "WVRSectionModel.h"
//#import "WVRSQArrangeMaCell.h"
//#import "WVRSQArrangeMAHeader.h"
//#import "WVRHttpProgramPackageReformer.h"

@interface WVRUnityTempTopicView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) WVRItemModel *dataModel;

@property (nonatomic, weak) UICollectionView *mainView;

@property (nonatomic, strong) UICollectionReusableView *headerView;
@property (nonatomic, assign) CGSize headerSize;

@end


@implementation WVRUnityTempTopicView
static NSString *kUnityTempTopicCellId = @"kUnityTempTopicCellId";
static NSString *kUnityTempTopicHeaderId = @"kUnityTempTopicHeaderId";

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dataDict {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"data"] = dataDict;
        
        Class cls = NSClassFromString(@"WVRHttpProgramPackageReformer");
        id reformer = [[cls alloc] init];
        
        _dataModel = [reformer performSelector:@selector(reformData:) withObject:dict];
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    [self createMainView];
}

- (void)createMainView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(self.width, adaptToWidth(258));
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    
    [mainView registerNib:[UINib nibWithNibName:@"WVRSQArrangeMACell" bundle:nil] forCellWithReuseIdentifier:kUnityTempTopicCellId];
    [mainView registerNib:[UINib nibWithNibName:@"WVRSQArrangeMAHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUnityTempTopicHeaderId];
    
    [self addSubview:mainView];
    _mainView = mainView;
}

- (UICollectionReusableView *)headerView {
    if (!_headerView) {
        
        _headerView = [self.mainView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUnityTempTopicHeaderId forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [_headerView performSelector:@selector(setSectionModel:) withObject:_dataModel];
    }
    
    return _headerView;
}

- (CGSize)headerSize {
    if (_headerSize.width == 0) {
        
        NSString *string = _dataModel.subTitle;
        
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 6;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12) range:NSMakeRange(0, string.length)];
        
        CGSize sizeL = [WVRComputeTool sizeOfString:attrString Size:CGSizeMake(SCREEN_WIDTH - fitToWidth(15 * 2), 2000)];
        
        _headerSize = CGSizeMake(SCREEN_WIDTH, adaptToWidth(211 + 100) + sizeL.height);
    }
    return _headerSize;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *arr = [self.dataModel performSelector:@selector(itemModels)];
    
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = [self.dataModel performSelector:@selector(itemModels)];
    WVRItemModel *item = [arr objectAtIndex:indexPath.item];
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUnityTempTopicCellId forIndexPath:indexPath];
    
    [cell performSelector:@selector(setItemModel:) withObject:item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUnityTempTopicHeaderId forIndexPath:indexPath];
        
        [headerView performSelector:@selector(setSectionModel:) withObject:_dataModel];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return self.headerSize;
}

@end
