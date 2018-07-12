//
//  WVRTVDetailCollectionView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVDetailCollectionView.h"
#import "WVRTVDetailTitleCell.h"
#import "WVRTVIntrCell.h"
#import "WVRSQFindSplitCell.h"
#import "WVRSQFindUIStyleHeader.h"
#import "WVRTVDetailHeader.h"
#import "WVRTVDetailWorkCell.h"
#import "WVRTVMActorsCell.h"

#define VER_COUNT_WORKCELL (6)
#define WIDTH_WORK_VER_LINE (1.f)

#define WIDTH_WORKCELL ((SCREEN_WIDTH - VER_COUNT_WORKCELL * WIDTH_WORK_VER_LINE) / VER_COUNT_WORKCELL)

@interface WVRTVDetailCollectionLayout ()

/** 所有的布局属性 */
@property (nonatomic, strong) NSArray *attrsArray;

@end


@interface WVRTVDetailCollectionView ()

@property (nonatomic) NSMutableDictionary * mModelDic;
@property (nonatomic) NSMutableDictionary * mOriginDic;
@property (nonatomic) SQCollectionViewDelegate * mDelegate;
@property (nonatomic) WVRTVDetailCollectionViewInfo * mVInfo;

@property (nonatomic) WVRTVDetailWorkCellInfo * selectCellInfo;

@property (nonatomic) NSArray * allWorkCellInfos;

@property (nonatomic) NSArray * introCellInfos;

@end


@implementation WVRTVDetailCollectionView

+ (instancetype)createWithInfo:(WVRTVDetailCollectionViewInfo *)vInfo {
    
    WVRTVDetailCollectionLayout* layout = [WVRTVDetailCollectionLayout new];
    WVRTVDetailCollectionView * pageV = [[WVRTVDetailCollectionView alloc] initWithFrame:vInfo.frame collectionViewLayout:layout withVInfo:vInfo];
    
    return pageV;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withVInfo:(WVRTVDetailCollectionViewInfo *)vInfo {
    
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.mVInfo = vInfo;
//        self.curItemModel = vInfo.itemModel;
        self.mOriginDic = [NSMutableDictionary dictionary];
        self.backgroundColor = UIColorFromRGB(0xebeff2);
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRTVDetailTitleCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRTVDetailTitleCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRTVIntrCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRTVIntrCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRSQFindSplitCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRSQFindSplitCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRTVDetailWorkCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRTVDetailWorkCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRTVMActorsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WVRTVMActorsCell class])];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WVRTVDetailHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WVRTVDetailHeader class])];
        SQCollectionViewDelegate * delegate = [SQCollectionViewDelegate new];
        self.delegate = delegate;
        self.dataSource = delegate;
        self.mDelegate = delegate;
        
        [self requestInfo];
    }
    return self;
}

- (void)requestInfo {
    
    self.allWorkCellInfos = [self getCellInfos:(int)self.mVInfo.itemModel.tvSeries.count];
    
    self.mOriginDic[@(0)] = [self getSectionInfo];
    if ([self.mVInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_MORETVPROGRAM]) {
        self.mOriginDic[@(1)] = [self getSelectedWorksSectionInfo];
    }
    [self updateCollectionView];
}

- (void)updateCollectionView {
    
    [self.mDelegate loadData:self.mOriginDic];
    [self reloadData];
}

- (SQCollectionViewSectionInfo*)getSectionInfo {
    
//    kWeakSelf(self);
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    WVRTVDetailTitleCellInfo * cellInfo = [WVRTVDetailTitleCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRTVDetailTitleCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(82.5f));
    cellInfo.itemModel = self.mVInfo.itemModel;
    [cellInfos addObject:cellInfo];
    
    
    self.introCellInfos = [self getIntrCellInfoToCellInfos];
    
    [cellInfos addObjectsFromArray:self.introCellInfos];
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (NSMutableArray *)getIntrCellInfoToCellInfos {
    
    NSMutableArray* cellInfos = [NSMutableArray new];
    [self checkAddActorCellInfoTo:cellInfos];
    WVRTVIntrCellInfo * introCellInfo = [WVRTVIntrCellInfo new];
    introCellInfo.cellNibName = NSStringFromClass([WVRTVIntrCell class]);
    
    NSString *string = [NSString stringWithFormat:@"简介：%@", self.mVInfo.itemModel.intrDesc ?: @""];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6.0f;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12.5f) range:NSMakeRange(0, string.length)];
    CGSize sizeL = [WVRComputeTool sizeOfString:attrString Size:CGSizeMake(SCREEN_WIDTH-fitToWidth(15.0*2.0), 2000.0)];
    
    introCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(33) + sizeL.height);
    introCellInfo.itemModel = self.mVInfo.itemModel;
    [cellInfos addObject:introCellInfo];
    
    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
    splitCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
    [cellInfos addObject:splitCellInfo];
    
    return cellInfos;
}

- (void)checkAddActorCellInfoTo:(NSMutableArray*)cellInfos {
    
    if ([self.mVInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_MOREMOVIEPROGRAM]) {
        NSString *string = self.mVInfo.itemModel.actors;
        if (!string) {
            string = @"";
        }
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 6.0f;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12.5f) range:NSMakeRange(0, string.length)];
        CGSize sizeL = [WVRComputeTool sizeOfString:attrString Size:CGSizeMake(SCREEN_WIDTH-fitToWidth(15.0*2.0), 2000.0)];
        WVRTVMActorsCellInfo * cellInfo = [WVRTVMActorsCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRTVMActorsCell class]);
        cellInfo.model = self.mVInfo.itemModel;
        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(68.f)+sizeL.height);
        [cellInfos addObject:cellInfo];
    }
}

- (void)updateTitleCellInfo {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(0)];
    WVRTVDetailTitleCellInfo * cellInfo = [sectionInfo.cellDataArray firstObject];
    cellInfo.itemModel = self.mVInfo.itemModel;
}

- (SQCollectionViewSectionInfo*)getSelectedWorksSectionInfo {
    
    kWeakSelf(self);
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    WVRTVDetailHeaderInfo * headerInfo = [WVRTVDetailHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRTVDetailHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(52.5f));
    headerInfo.itemModel = self.mVInfo.itemModel;
    headerInfo.gotoNextBlock = ^(WVRTVDetailHeaderInfo * args) {
        [weakself workHeaderBlock:args sectionInfo:sectionInfo];
    };
    sectionInfo.headerInfo = headerInfo;
    [self closeWorkHeader:sectionInfo];
    return sectionInfo;
}

- (void)workHeaderBlock:(WVRTVDetailHeaderInfo * )headerInfo sectionInfo:(SQCollectionViewSectionInfo * )sectionInfo {
    
    if (headerInfo.isOpen) {
        NSMutableArray * cellInfos = (NSMutableArray *)[self.mOriginDic[@(0)] cellDataArray];
        [cellInfos addObjectsFromArray:self.introCellInfos];
        [self closeWorkHeader:sectionInfo];
    } else {
        sectionInfo.cellDataArray = [NSMutableArray arrayWithArray:self.allWorkCellInfos];
        NSMutableArray * cellInfos = (NSMutableArray *)[self.mOriginDic[@(0)] cellDataArray];
        [cellInfos removeObjectsInArray:self.introCellInfos];
    }
    headerInfo.isOpen = !headerInfo.isOpen;
    [self reloadData];
}

- (void)closeWorkHeader:(SQCollectionViewSectionInfo * )sectionInfo {
    
    if (self.allWorkCellInfos.count > 0) {
        NSArray * cur = [self.allWorkCellInfos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(VER_COUNT_WORKCELL * 2 - 1, self.allWorkCellInfos.count))]];
        sectionInfo.cellDataArray = [NSMutableArray arrayWithArray:cur];
    }
}

- (NSMutableArray *)getCellInfos:(int)maxNum {
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (int i = 0; i < maxNum; i++) {
        if(self.mVInfo.itemModel.tvSeries.count<=i){
            break;
        }
        [self addCellInfoTo:cellInfos index:i];
        if ((i + 1) % VER_COUNT_WORKCELL != 0) {
            [cellInfos addObject:[self getVerSplitCellInfo]];
        }
    }
    
//    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
//    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
//    splitCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
//    [cellInfos addObject:splitCellInfo];
    
    return cellInfos;
}

- (void)addCellInfoTo:(NSMutableArray*)cellInfos index:(int)index {
    
    kWeakSelf(self);
    WVRTVDetailWorkCellInfo * cellInfo = [WVRTVDetailWorkCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRTVDetailWorkCell class]);
    cellInfo.cellSize = CGSizeMake(WIDTH_WORKCELL, WIDTH_WORKCELL);
    cellInfo.itemModel = self.mVInfo.itemModel.tvSeries[index];
    cellInfo.selected = [self.mVInfo.itemModel.curEpisode intValue]==[cellInfo.itemModel.curEpisode intValue];
    if (cellInfo.selected) {
        self.selectCellInfo = cellInfo;
    }
    kWeakSelf(cellInfo);
    cellInfo.didSelectBlock = ^{
        [weakself didSelectItemBlock:weakcellInfo cellInfos:cellInfos];
    };
    [cellInfos addObject:cellInfo];
}

- (void)didSelectItemBlock:(WVRTVDetailWorkCellInfo*)cellInfo cellInfos:(NSArray*)cellInfos {
    
    [self updateSelectItemInfo:cellInfo];
    if ([self.selectDelegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.selectDelegate didSelectItem:self.mVInfo.itemModel];
    }
    
}

- (void)updateSelectItemInfo:(WVRTVDetailWorkCellInfo*)cellInfo {
    
    if (cellInfo.selected) {
        return;
    }
    [self resetCellInfoStatus];
    cellInfo.selected = !cellInfo.selected;
    self.mVInfo.itemModel.code = cellInfo.itemModel.code;
    self.mVInfo.itemModel.name = cellInfo.itemModel.name;
    self.mVInfo.itemModel.playCount = cellInfo.itemModel.playCount;
    self.mVInfo.itemModel.curEpisode = cellInfo.itemModel.curEpisode;
    self.mVInfo.itemModel.playUrlModels = cellInfo.itemModel.playUrlModels;
    if (cellInfo.itemModel.thubImageUrl) {
        self.mVInfo.itemModel.thubImageUrl = cellInfo.itemModel.thubImageUrl;
    }
    if (cellInfo.itemModel.intrDesc) {
        self.mVInfo.itemModel.intrDesc = cellInfo.itemModel.intrDesc;
    }
//    [self updateTitleCellInfo];
    self.selectCellInfo = cellInfo;
//    [self reloadData];
}

- (void)resetCellInfoStatus {
    
    if ([self.selectCellInfo isKindOfClass:[WVRTVDetailWorkCellInfo class]]) {
        self.selectCellInfo.selected = NO;
    }
}

- (void)selectNextItem {
    
    [self resetCellInfoStatus];
    for (WVRTVDetailWorkCellInfo * cellInfo in self.allWorkCellInfos) {
        if (cellInfo == self.selectCellInfo) {
            NSInteger curIndex = [self.allWorkCellInfos indexOfObject:cellInfo];
            NSInteger nexIndex = curIndex+1;
            if (nexIndex<self.allWorkCellInfos.count) {
                WVRTVDetailWorkCellInfo * nexCellInfo = [self.allWorkCellInfos objectAtIndex:nexIndex];
                if ([nexCellInfo isKindOfClass:[WVRSQFindSplitCellInfo class]]) {
                    nexIndex += 1;
                }
                if (nexIndex<self.allWorkCellInfos.count) {
                    nexCellInfo = [self.allWorkCellInfos objectAtIndex:nexIndex];
                    [self updateSelectItemInfo:nexCellInfo];
                    break;
                }
            }
        }
    }
}

- (SQCollectionViewCellInfo*)getVerSplitCellInfo {
    
    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
    splitCellInfo.cellSize = CGSizeMake(WIDTH_WORK_VER_LINE, WIDTH_WORKCELL);
    return splitCellInfo;
}
@end
@implementation WVRTVDetailCollectionViewInfo

@end

@implementation WVRTVDetailCollectionLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect]; //mutableCopy];
    //    for (UICollectionViewLayoutAttributes *attr in attributes) {
    //        NSLog(@"%@", NSStringFromCGRect([attr frame]));
    //    }
    //从第二个循环到最后一个
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 0;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}

@end

