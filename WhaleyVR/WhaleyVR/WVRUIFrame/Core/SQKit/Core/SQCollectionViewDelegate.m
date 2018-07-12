//
//  SQCollectionViewDelegate.m
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/14.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "SQKitHeader.h"

@interface SQCollectionViewDelegate ()

@property (nonatomic) NSDictionary *mOriginDic;
@property (atomic, assign) BOOL isExecBlock;

@end


@implementation SQCollectionViewDelegate

#pragma mark - loadData

- (void)loadData:(NSDictionary *)data {
    
    self.mOriginDic = [data copy];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQBaseCollectionViewInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.gotoNextBlock) {
        cellInfo.gotoNextBlock(cellInfo);
    }
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SQBaseCollectionViewCell* cell = (SQBaseCollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell didHighlight];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SQBaseCollectionViewCell* cell = (SQBaseCollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell didUnhighlight];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.mOriginDic.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    sectionInfo.sectionIndex = section;
    
    return sectionInfo.cellDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQBaseCollectionViewInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    SQBaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInfo.cellNibName ?: cellInfo.cellClassName forIndexPath:indexPath];
    cellInfo.cellIndex = indexPath.row;
//    if (cellInfo.viewTag != cell || cellInfo.needRefresh) {
        cellInfo.viewTag = cell;
        [cell fillData:cellInfo];
//    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        SQCollectionViewHeaderInfo * headerInfo = sectionInfo.headerInfo;
        SQBaseCollectionReusableHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerInfo.cellNibName ?: headerInfo.cellClassName forIndexPath:indexPath];
//        if (headerInfo.viewTag!=headerView||headerInfo.needRefresh) {
            [headerView fillData:headerInfo];
//        }
        reusableview = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        SQCollectionViewFooterInfo * footerInfo = sectionInfo.footerInfo;
        SQBaseCollectionReusableFooter *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerInfo.cellNibName ?: footerInfo.cellClassName forIndexPath:indexPath];
//        if (footerInfo.viewTag != footerview || footerInfo.needRefresh) {
            [footerview fillData:footerInfo];
//        }
        reusableview = footerview;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQBaseCollectionViewInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    
    return cellInfo.cellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQCollectionViewHeaderInfo * headerInfo = sectionInfo.headerInfo;
    
//    NSLog(@"header size: height:%f", headerInfo.cellSize.height);
    return headerInfo.cellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQCollectionViewFooterInfo * footerInfo = sectionInfo.footerInfo;
    
    return footerInfo.cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    
    return sectionInfo.minLineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    
    return sectionInfo.minItemSpace;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    SQCollectionViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    
    return sectionInfo.edgeInsets;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.DidEndDecelerating) {
        self.DidEndDecelerating(scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentXoffset = scrollView.contentOffset.x;
    CGFloat distanceFromBottomX = contentXoffset + width - scrollView.contentSize.width;
    
    if (distanceFromBottomX < 0) {
        
        _isExecBlock = YES;
    } else {
        _isExecBlock = NO;
    }
    if (self.WillBeginDragging) {
        self.WillBeginDragging(scrollView);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentXoffset = scrollView.contentOffset.x;
    CGFloat distanceFromBottomX = contentXoffset + width - scrollView.contentSize.width;
    
//    NSLog(@"contentXoffset:%d  distance:%d", (int)contentXoffset, (int)distanceFromBottomX);
    
    if (distanceFromBottomX >= 0) {
        
        if (self.scrollBottomBlock && !_isExecBlock) {
            _isExecBlock = YES;
            self.scrollBottomBlock(YES);
        }
    }
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
//    if (contentYoffset<=kNavBarHeight) {
        if (self.scrollDidScrolling) {
            self.scrollDidScrolling(contentYoffset);
        }
//    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    CGFloat width = scrollView.frame.size.width;
//    CGFloat contentXoffset = scrollView.contentOffset.x;
//    CGFloat distanceFromBottomX = contentXoffset + width - scrollView.contentSize.width;

    if (self.scrollDidToTop) {
        self.scrollDidToTop(YES);
    }
}

@end


@implementation SQBaseCollectionViewInfo

@end


@implementation SQCollectionViewHeaderInfo

@end


@implementation SQCollectionViewFooterInfo

@end


@implementation SQCollectionViewSectionInfo

@end


@implementation SQCollectionViewCellInfo

@end


@implementation SQBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
//        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
//        float w = roundf(CGRectGetWidth([[UIScreen mainScreen] bounds]) / NORMAL_SCREEN_WIDTH*constraint.constant * 10) / 10.f;
        constraint.constant = SQFITSCREEN(constraint.constant);
        ;
    }
    NSArray* subviews = self.subviews;
    for (UIView * view in subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
//            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = SQFITSCREEN(constraint.constant);
        }
    }
}

- (void)fillData:(SQBaseCollectionViewInfo*)info {
    
    NSAssert(YES, @"must ovrried in sub class");
}

- (void)didHighlight {
    

}

- (void)didUnhighlight {
    

}

@end


@implementation SQBaseCollectionReusableHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
//        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
        constraint.constant = SQFITSCREEN(constraint.constant);
    }
    
    for (UIView * view in self.subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
//            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = SQFITSCREEN(constraint.constant);
        }
    }
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    NSAssert(YES, @"must ovrried in sub class");
}

@end


@implementation SQBaseCollectionReusableFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
//        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
        constraint.constant = SQFITSCREEN(constraint.constant);
    }
    
    for (UIView * view in self.subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
//            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = SQFITSCREEN(constraint.constant);
        }
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat inteval = CGRectGetHeight(contentRect)/8.0;
    
    //设置图片的宽高为button高度的3/4;
    CGFloat imageH = CGRectGetHeight(contentRect) - 22 * inteval;
    
    CGRect rect = CGRectMake(CGRectGetWidth(contentRect) - imageH - inteval, inteval, imageH, imageH);
    
    return rect;
}

- (void)updateButtonEdgeInsets:(UIButton*)btn {
    
    
    btn.titleLabel.backgroundColor = btn.backgroundColor;
    btn.imageView.backgroundColor = btn.backgroundColor;

    CGSize titleSize = btn.titleLabel.bounds.size;
    NSLog(@"titleSize:%f",titleSize.width);
    CGSize imageSize = btn.imageView.bounds.size;
    CGFloat contentWidth = titleSize.width+imageSize.width;
    CGFloat widthOffset = (btn.frame.size.width-contentWidth)/2*contentWidth*contentWidth;
    UIEdgeInsets edgeInsers = btn.titleEdgeInsets;
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, fitToWidth(edgeInsers.left), fitToWidth(edgeInsers.bottom), fitToWidth(edgeInsers.right));
    edgeInsers = btn.imageEdgeInsets;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, widthOffset+SQFITSCREEN(6), 0, 0);
//    edgeInsers = btn.contentEdgeInsets;
//    btn.contentEdgeInsets = UIEdgeInsetsMake(fitToWidth(edgeInsers.top), fitToWidth(edgeInsers.left), fitToWidth(edgeInsers.bottom), fitToWidth(edgeInsers.right));
    
}
- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    NSAssert(YES, @"must ovrried in sub class");
}

- (void)dealloc {
//    DebugLog(@"");
}

@end
