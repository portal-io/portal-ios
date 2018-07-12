//
//  WVRHistoryController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryController.h"
#import "WVRGotoNextTool.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRDeleteFooterView.h"
#import "WVRHistoryViewModel.h"
#import "WVRHistoryCell.h"
#import "WVRHistoryModel.h"
#import "WVRSectionModel.h"
#import "WVRRewardSectionHeader.h"

#import "WVRHistoryHeaderView.h"
#import "UIAlertController+Extend.h"

@interface WVRHistoryController ()

@property (nonatomic, strong) WVRHistoryViewModel * gViewModel;

@end

@implementation WVRHistoryController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:NAME_NOTF_HISTORY_REFRESH object:nil];
}

-(WVRHistoryViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRHistoryViewModel alloc] init];
    }
    return _gViewModel;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

-(void)installRAC
{
    @weakify(self);
    [[self.gViewModel gHistoryCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gViewModel gHistoryFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:x];
    }];
}

-(void)httpFailBlock:(id)x
{
    [super httpFailBlock:x];
    
}

- (void)initTitleBar
{
    [super initTitleBar];
    self.title = @"浏览历史";
}



-(NSString *)nullViewTitle
{
    return @"暂无观看历史";
}

-(NSString *)nullViewIcon
{
    return @"local_video_empty";
}

-(void)doMultiDelete
{
    if (self.gTableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSMutableArray * codes = [NSMutableArray array];
        NSArray *indexPaths = [self.gTableView indexPathsForSelectedRows];
        
        NSMutableDictionary * sectionModelDic = [NSMutableDictionary dictionary];
        NSMutableDictionary * sectionInfoDic = [NSMutableDictionary dictionary];
        
        for (NSIndexPath* indexPath in indexPaths) {
            WVRSectionModel* sectionModel = self.mOriginArray[indexPath.section];
            //组装row
            SQTableViewSectionInfo * sectionInfo = self.originDic[@(indexPath.section)];
            
            NSMutableArray *deloriginItems = sectionModelDic[@(indexPath.section)];
            if (!deloriginItems) {
                deloriginItems = [NSMutableArray new];
                sectionModelDic[@(indexPath.section)] = deloriginItems;
            }
            NSMutableArray *deletedDeals = sectionInfoDic[@(indexPath.section)];
            if (!deletedDeals) {
                deletedDeals = [NSMutableArray new];
                sectionInfoDic[@(indexPath.section)] = deletedDeals;
            }
            
            WVRHistoryModel * model = [sectionInfo.cellDataArray[indexPath.row] args];
            [codes addObject:model.uid];
            
            [deloriginItems addObject:sectionModel.itemModels[indexPath.row]];
            [deletedDeals addObject:sectionInfo.cellDataArray[indexPath.row]];
        }
        
        for (NSNumber * num in [sectionModelDic allKeys]) {
            WVRSectionModel* sectionModel = self.mOriginArray[[num integerValue]];
            //组装row
            SQTableViewSectionInfo * sectionInfo = self.originDic[num];
            [sectionModel.itemModels removeObjectsInArray:sectionModelDic[num]];
            [sectionInfo.cellDataArray removeObjectsInArray:sectionInfoDic[num]];
        }
        // 刷新表格  一定要刷新数据
        [self.gTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
        [self refreshUI];
        [self multiDelete:codes];
    }
}

- (void)requestInfo
{
    [super requestInfo];
    SQShowProgress;
}

- (void)headerRequestInfo
{
    [[self.gViewModel getHistoryCmd] execute:nil];
    
}

-(SQTableViewSectionInfo *)getSectionInfo:(WVRSectionModel*)sectionModel
{
    kWeakSelf(self);
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    WVRHistoryHeaderViewInfo * headerInfo = [WVRHistoryHeaderViewInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRHistoryHeaderView class]);
    headerInfo.args = sectionModel.formatDateKey;
    headerInfo.cellHeight = fitToWidth(80.0/2.0f);
    sectionInfo.headViewInfo = headerInfo;
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRHistoryModel* model in sectionModel.itemModels) {
        WVRHistoryCellInfo * cellInfo = [WVRHistoryCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRHistoryCell class]);
        if (model == [sectionModel.itemModels firstObject]) {
            cellInfo.cellHeight = fitToWidth(85.0f);
        }else{
            cellInfo.cellHeight = fitToWidth(95.0f);
        }
        
        cellInfo.args = model;
        cellInfo.gotoNextBlock = ^(id args){
            weakself.selectAll = NO;
            if (weakself.gTableView.allowsMultipleSelectionDuringEditing) {
                [weakself updateSelectedCount];
                return ;
            }
            [weakself gotoParameDetailVC:model];
        };
        cellInfo.willDeleteBlock = ^(WVRHistoryCellInfo* args){
            return [weakself deleteItemBlock:cellInfos indexPath:args.indexPath];
        };
        cellInfo.deselectBlock = ^(id args){
            if (weakself.gTableView.allowsMultipleSelectionDuringEditing) {
                [weakself updateSelectedCount];
                return ;
            }
        };
        [cellInfos addObject:cellInfo];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}


- (void)gotoParameDetailVC:(WVRHistoryModel*)model
{
    model.linkArrangeValue = model.programCode;
    if ([model.playTime isEqualToString:model.totalPlayTime]) {
        model.playTime = @"0";
    }
    if ([model.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
        model.playTime = @"0";
    }
    [WVRGotoNextTool gotoNextVC:model nav:self.navigationController];
}

- (BOOL)deleteItemBlock:(NSMutableArray*)cellInfos indexPath:(NSIndexPath*)indexPath
{
    WVRHistoryModel * model = [cellInfos[indexPath.row] args];
    self.gViewModel.delIds = model.uid;
    [[self.gViewModel getHistoryDelCmd] execute:nil];
    WVRSectionModel * sectionModel = self.mOriginArray[indexPath.section];
    [sectionModel.itemModels removeObjectAtIndex:indexPath.row];
    [cellInfos removeObjectAtIndex:indexPath.row];
    [self refreshUI];
    return NO;
}

- (void)multiDelete:(NSArray*)codes
{
    if (self.selectAll) {
        [[self.gViewModel getHistoryDelAllCmd] execute:nil];

    }else{
        NSString * curCode = @"";
        for (NSString * code in codes) {
            curCode = [curCode stringByAppendingString:code];
            curCode = [curCode stringByAppendingString:@","];
        }
        curCode = [curCode substringToIndex:curCode.length-1];
        self.gViewModel.delIds = curCode;
        [[self.gViewModel getHistoryDelCmd] execute:nil];

    }
}

@end
