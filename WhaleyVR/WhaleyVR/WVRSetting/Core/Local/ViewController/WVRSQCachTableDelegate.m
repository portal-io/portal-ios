//
//  WVRSQCachTableDelegate.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQCachTableDelegate.h"
#import "SQTableViewDelegate.h"

@interface WVRSQCachTableDelegate ()

@property (nonatomic) NSDictionary * mOriginDic;

@end
@implementation WVRSQCachTableDelegate

#pragma mark loadDataBlock
-(void)loadData:(NSDictionary *(^)(void)) loadDataBlock
{
    self.mOriginDic = [loadDataBlock() mutableCopy];
}

//-(NSString*)kSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%ld",(long)section];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mOriginDic.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    return sectionInfo.cellDataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    cellInfo.indexPath = indexPath;
    
    NSString * cellId = [NSString stringWithFormat:@"%@%ld%ld",cellInfo.cellNibName,(long)indexPath.section,(long)indexPath.row];
     SQBaseTableViewCell * cell = (SQBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        UINib * nib = [UINib nibWithNibName:cellInfo.cellNibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = (SQBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    }
    [cell fillData:cellInfo];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect %ld",(long)indexPath.row);
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.deselectBlock) {
        cellInfo.deselectBlock(cellInfo);
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if (!tableView.allowsMultipleSelectionDuringEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.gotoNextBlock) {
        cellInfo.gotoNextBlock(cellInfo);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

#pragma mark--
#pragma mark cell for section delegate
-(SQBaseTableViewCell*)cellForSection:(SQBaseTableViewInfo *)cellInfo tableView:(UITableView*)tableView
{
    SQBaseTableViewCell* cell ;
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {
        cell = [self loadNibCellWithNibName:nibName tableView:tableView reuseIdentifier:nibName];
    }else
    {
        cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
    }
    return cell;
}

-(SQBaseTableViewCell*)loadNibCellWithNibName:(NSString*)nibName tableView:(UITableView *)tableView reuseIdentifier:(NSString*)reuseId
{
    UINib * nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseId];
    return (SQBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
}

#pragma mark --
#pragma mark View for head
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    SQBaseTableViewCell * cell = (SQBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:viewInfo.cellNibName? viewInfo.cellNibName:viewInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:viewInfo tableView:tableView];
    }
    [cell fillData:viewInfo];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    SQBaseTableViewCell * cell = (SQBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:viewInfo.cellNibName? viewInfo.cellNibName:viewInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:viewInfo tableView:tableView];
    }
    [cell fillData:viewInfo];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(indexPath.section)];
    SQTableViewCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    return  cellInfo.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    return  viewInfo.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = self.mOriginDic[@(section)];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    return  viewInfo.cellHeight;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEdit;
}

@end
