//
//  WVRCollectionController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionController.h"
#import "WVRCollectionViewModel.h"
#import "WVRCollectionCell.h"
#import "WVRGotoNextTool.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRDeleteFooterView.h"
#import "WVRTableView.h"
#import "WVRTVItemModel.h"

@interface WVRCollectionController ()

@property (nonatomic, strong) WVRCollectionViewModel * gCollectionViewModel;

@property (nonatomic, assign) NSInteger gCurDelIndex;

@end


@implementation WVRCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

-(WVRCollectionViewModel *)gCollectionViewModel
{
    if (!_gCollectionViewModel) {
        _gCollectionViewModel = [[WVRCollectionViewModel alloc] init];
    }
    return _gCollectionViewModel;
}


-(void)installRAC
{
    @weakify(self);
    [[self.gCollectionViewModel gCollectionCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gCollectionViewModel gCollectionFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:x];
    }];
    
    
}

- (void)initTitleBar {
    
    [super initTitleBar];
    self.title = @"我的播单";
}

-(NSString *)nullViewTitle
{
    return @"暂无收藏视频";
}

-(NSString *)nullViewIcon
{
    return @"local_video_empty";
}

- (void)updateSelectedCount {
    
    NSArray* indexPaths = [self.gTableView indexPathsForSelectedRows];
    NSInteger totalCount = self.mOriginArray.count;
    NSString * title = [NSString stringWithFormat:@"删除（%ld/%ld）", (unsigned long)indexPaths.count, totalCount];
    if(indexPaths.count == totalCount){
        [self.mDelFooterV updateSelectStatus:YES];
    }else{
        [self.mDelFooterV updateSelectStatus:NO];
    }
    [self.mDelFooterV updateDelTitle:title];
}

- (void)doMultiDelete {
    
    if (self.gTableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSArray *indexPaths = [self.gTableView indexPathsForSelectedRows];
        if (indexPaths.count==0) {
            return;
        }
        SQTableViewSectionInfo * sectionInfo = self.originDic[@(SQTableViewSectionStyleFir)];
        // 便利所有的行号
        NSMutableArray *deletedDeals = [NSMutableArray array];
        NSMutableArray * vcModels = [NSMutableArray array];
        NSMutableArray * codes = [NSMutableArray array];
        for (NSIndexPath *path in indexPaths) {
            WVRCollectionModel * model = self.mOriginArray[path.row];
            [codes addObject:model.programCode];
            [vcModels addObject:model];
            [deletedDeals addObject:sectionInfo.cellDataArray[path.row]];
        }
        // 删除模型数据
        [self.mOriginArray removeObjectsInArray:vcModels];
        [sectionInfo.cellDataArray removeObjectsInArray:deletedDeals];
        // 刷新表格  一定要刷新数据
        [self.gTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
        [self refreshUI];
        [self multiDelete:codes];
    }
    
}

- (void)headerRequestInfo {
    [[self.gCollectionViewModel getCollectionCmd] execute:nil];
    
}

- (void)parseForDic
{
    self.originDic[@(0)] = [self getSectionInfo];
}

- (SQTableViewSectionInfo*)getSectionInfo {
    
    kWeakSelf(self);
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRCollectionModel* model in self.mOriginArray) {
        WVRCollectionCellInfo * cellInfo = [WVRCollectionCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRCollectionCell class]);
        cellInfo.cellHeight = fitToWidth(95.0f);
        cellInfo.collectionModel = model;
        cellInfo.gotoNextBlock = ^(id args){
            if (weakself.gTableView.allowsMultipleSelectionDuringEditing) {
                [weakself updateSelectedCount];
                return ;
            }
            [weakself gotoParameDetailVC:model];
        };
        cellInfo.willDeleteBlock = ^(WVRCollectionCellInfo* args){
            return [weakself deleteItemBlock:cellInfos index:args.indexPath.row];
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

- (void)gotoParameDetailVC:(WVRCollectionModel*)model {
    
    [WVRTrackEventMapping trackEvent:@"collection" flag:@"topic"];
    
    model.linkArrangeValue = model.programCode;
    [WVRGotoNextTool gotoNextVC:model nav:self.navigationController];
}

- (BOOL)deleteItemBlock:(NSMutableArray*)cellInfos index:(NSInteger)index {
    WVRCollectionModel * model = self.mOriginArray[index];
    self.gCollectionViewModel.delIds = model.programCode;
    [[self.gCollectionViewModel getCollectionDelCmd] execute:nil];
    [self.mOriginArray removeObjectAtIndex:index];
    [cellInfos removeObjectAtIndex:index];
    [self refreshUI];
    return NO;
}

- (void)multiDelete:(NSArray*)codes {
    NSString * curCode = @"";
    for (NSString * code in codes) {
        curCode = [curCode stringByAppendingString:code];
        curCode = [curCode stringByAppendingString:@","];
    }
    self.gCollectionViewModel.delIds = curCode;
    [[self.gCollectionViewModel getCollectionDelCmd] execute:nil];
}



@end
