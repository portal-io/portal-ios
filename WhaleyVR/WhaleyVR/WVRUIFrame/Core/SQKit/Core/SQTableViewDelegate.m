//
//  SQTableViewDelegate.m
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "SQKitHeader.h"
#import "SNUtilToolHead.h"

@interface SQTableViewDelegate ()

@property (nonatomic, strong) NSMutableDictionary *mOriginDic;

@end


@implementation SQTableViewDelegate

#pragma mark loadDataBlock

- (void)loadData:(NSDictionary *(^)(void)) loadDataBlock {
    
    self.mOriginDic = [loadDataBlock() mutableCopy];
}

//- (NSString*)kSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%ld",(long)section];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mOriginDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];

    return sectionInfo.cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    cellInfo.indexPath = indexPath;
    SQBaseTableViewCell * cell = (SQBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellInfo.cellNibName? cellInfo.cellNibName:cellInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:cellInfo tableView:tableView];
    }
    [cell fillData:cellInfo];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"deselect %ld",(long)indexPath.row);
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.deselectBlock) {
        cellInfo.deselectBlock(cellInfo);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"select %ld",(long)indexPath.row);
    if (!tableView.allowsMultipleSelectionDuringEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.gotoNextBlock) {
        cellInfo.gotoNextBlock(cellInfo);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.didScrollBlock) {
        self.didScrollBlock();
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionTitles;
}

#pragma mark - cell for section delegate

- (SQBaseTableViewCell*)cellForSection:(SQBaseTableViewInfo *)cellInfo tableView:(UITableView*)tableView {
    
    SQBaseTableViewCell* cell ;
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {//是否需要单独定义reuseIdentifier功能
        cell = [self loadNibCellWithNibName:nibName tableView:tableView reuseIdentifier:nibName];
    }else
    {
        cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
    }
    return cell;
}

- (SQBaseTableViewCell*)loadNibCellWithNibName:(NSString*)nibName tableView:(UITableView *)tableView reuseIdentifier:(NSString*)reuseId {
    
    UINib * nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseId];
    return (SQBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
}

#pragma mark - View for head

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    SQBaseTableViewSectionView * cell = nil;
    if (viewInfo.cellNibName.length>0) {
        cell = (SQBaseTableViewSectionView *)VIEW_WITH_NIB(viewInfo.cellNibName);
    } else if(viewInfo.cellClassName.length > 0) {
        cell = [[NSClassFromString(viewInfo.cellClassName) alloc] init];
    }
     //(SQBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:viewInfo.cellNibName? viewInfo.cellNibName:viewInfo.cellClassName];
//    if (nil == cell) {
//        cell = [self cellForSection:viewInfo tableView:tableView];
//    }
    [cell fillData:viewInfo];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    SQBaseTableViewSectionView * cell = nil;
    if (viewInfo.cellNibName.length>0) {
        cell = (SQBaseTableViewSectionView *)VIEW_WITH_NIB(viewInfo.cellNibName);
    }else if(viewInfo.cellClassName.length>0){
        cell = [[NSClassFromString(viewInfo.cellClassName) alloc] init];
    }    [cell fillData:viewInfo];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
//    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
//    return  cellInfo.cellHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    return  cellInfo.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    return  viewInfo.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    return  viewInfo.cellHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.editStyle;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UITableViewCellEditingStyleDelete) {
        BOOL delResult = NO;
        SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
        SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
        if (cellInfo.willDeleteBlock) {
           delResult = cellInfo.willDeleteBlock(cellInfo);
        }
        if(delResult){
            [sectionInfo.cellDataArray removeObject:cellInfo];
            [tableView reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.canEdit;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SQBaseTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell didHighlight];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SQBaseTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell didUnhighlight];
}

@end


@implementation SQBaseTableViewInfo

@end


@implementation SQTableViewHeadViewInfo

@end


@implementation SQTableViewFootViewInfo

@end


@implementation SQTableViewSectionInfo
@synthesize cellDataArray = _cellDataArray;

- (NSMutableArray *)cellDataArray {
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

@end


@implementation SQTableViewCellInfo

@end


@implementation SQBaseTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //据底部0
        constraint.constant = SQFITSCREEN(constraint.constant);
    }
    NSArray* subViews = self.contentView.subviews;
    for (UIView *view in subViews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            //据底部0
            constraint.constant = SQFITSCREEN(constraint.constant);
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    NSAssert(YES, @"must ovrried in sub class");
}

- (void)updateTableView:(SQBaseTableViewInfo *)info animal:(UITableViewRowAnimation)animal {
    
    [(UITableView *)(self.superview.superview) reloadRowsAtIndexPaths:@[info.indexPath] withRowAnimation:animal];
}

- (void)didHighlight {
    
}

- (void)didUnhighlight {
    
}

@end


@implementation SQBaseTableViewSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //据底部0
        constraint.constant = SQFITSCREEN(constraint.constant);
    }
    NSArray* subViews = self.subviews;
    for (UIView *view in subViews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            //据底部0
            constraint.constant = SQFITSCREEN(constraint.constant);
        }
    }
}

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    NSAssert(YES, @"must ovrried in sub class");
}

- (void)updateTableView:(SQBaseTableViewInfo*)info animal:(UITableViewRowAnimation)animal {
    
    [(UITableView *)(self.superview.superview) reloadRowsAtIndexPaths:@[info.indexPath] withRowAnimation:animal];
}

- (void)didHighlight {
    
}

- (void)didUnhighlight {
    
    
}

@end

