//
//  WVREditTableViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVREditTableViewController.h"
#import "WVRSectionModel.h"

#define HEIGHT_DELVIEW (44.f)

@interface WVREditTableViewController ()

@end

@implementation WVREditTableViewController
@synthesize gTableView = _gTableView;

//1. load data
//2. change to edit status
//3. change to unedit status
//4. 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self installRAC];
    self.originDic = [NSMutableDictionary new];
    [self.view addSubview:self.gTableView];
    [self initTableView];
    kWeakSelf(self);
    
    self.mJ_header = [SQRefreshHeader headerWithRefreshingBlock:^{
        [weakself.getEmptyView setHidden:YES];
        [weakself headerRequestInfo];
    }];
    [self requestInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:NAME_NOTF_HISTORY_REFRESH object:nil];
}

- (UITableView *)gTableView
{
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_gTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_gTableView];
        [_gTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(kNavBarHeight);
            make.bottom.equalTo(self.mDelFooterV.mas_top);
            make.width.mas_equalTo(self.view.width);
        }];
        
    }
    return _gTableView;
}

-(WVRDeleteFooterView *)mDelFooterV
{
    if (!_mDelFooterV) {
        WVRDeleteFooterView * delFooterV = (WVRDeleteFooterView*)VIEW_WITH_NIB(NSStringFromClass([WVRDeleteFooterView class]));
        [self.view addSubview:delFooterV];
        [delFooterV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(0.f);
        }];
        
        kWeakSelf(self);
        delFooterV.delBlock = ^{
            [weakself alertForMutilDel];
        };
        delFooterV.selectAllBlock = ^(BOOL selected){
            [weakself didSelectAllCell:selected];
        };
        _mDelFooterV = delFooterV;
    }
    return _mDelFooterV;
}

-(void)initTableView
{
    self.gTableView.delegate = self.tableDelegate;
    self.gTableView.dataSource = self.tableDelegate;
    self.gTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableDelegate.editStyle = UITableViewCellEditingStyleDelete;
    [self.tableDelegate setCanEdit:YES];
}

-(SQTableViewDelegate *)tableDelegate
{
    if (!_tableDelegate) {
        _tableDelegate = [[SQTableViewDelegate alloc] init];
    }
    return _tableDelegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


-(void)installRAC
{

}

-(void)httpSuccessBlock:(NSArray *)originArray
{
    SQHideProgress;
    [self clear];
    self.mOriginArray = [NSMutableArray arrayWithArray:originArray];
    if (!self.gTableView.mj_header) {
        self.gTableView.mj_header = self.mJ_header;
    }
    [self.gTableView.mj_header endRefreshing];
    [self refreshUI];

}

-(void)httpFailBlock:(id)x
{
    SQHideProgress;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.gTableView.mj_header endRefreshing];
    @weakify(self);
    [self showNetErrorVWithreloadBlock:^{
        @strongify(self);
        [self requestInfo];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initTitleBar
{
    [super initTitleBar];
    self.leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeToEditStatus)];
    self.navigationItem.rightBarButtonItem = self.editItem;
}

- (void)back
{
    if (self.isEditing) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.gTableView.contentSize.height - (self.gTableView.bounds.size.height-HEIGHT_DELVIEW);
    if (offset > 0)
    {
        [self.gTableView setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

- (void)changeToEditStatus
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        [self.gTableView setEditing:NO animated:NO];
        self.gTableView.allowsMultipleSelectionDuringEditing = YES;
        [self.gTableView setEditing:YES animated:YES];
        BOOL isBottom = self.gTableView.contentSize.height - self.gTableView.contentOffset.y <= self.gTableView.frame.size.height;
        if(isBottom){
            [self scrollsToBottomAnimated:YES];
        }
        [self loadDeleteFooterView];
        self.isEditing = YES;
        self.gTableView.mj_header = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain target:nil action:nil];
    }else{
        [self removeDeleteFooterView];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        self.gTableView.allowsMultipleSelectionDuringEditing = NO;
        [self.gTableView setEditing:NO animated:YES];
        self.isEditing = NO;
        self.navigationItem.leftBarButtonItem = self.leftItem;
        self.gTableView.mj_header = self.mJ_header;
    }
}

-(void)changeToDefaultStatus
{
    [self removeDeleteFooterView];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    self.gTableView.allowsMultipleSelectionDuringEditing = NO;
    [self.gTableView setEditing:NO animated:YES];
    self.isEditing = NO;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.gTableView.mj_header = self.mJ_header;
}

-(void)doMultiDelete
{
    
}

- (void)requestInfo
{
    [super requestInfo];
    if (self.originDic.count==0) {
        SQShowProgress;
    }
    [self headerRequestInfo];
}

- (void)headerRequestInfo
{
    
}

- (void)refreshUI
{
    [self parseForDic];
    if (self.mOriginArray.count==0) {
        [self showArrNullView:[self nullViewTitle] icon:[self nullViewIcon]];
        [self.originDic removeAllObjects];
        [self changeToDefaultStatus];
        self.navigationItem.rightBarButtonItem = nil;
        
        self.navigationItem.leftBarButtonItem = self.leftItem;
        self.gTableView.allowsMultipleSelectionDuringEditing = NO;
        [self.gTableView setEditing:NO animated:YES];
        [self removeDeleteFooterView];
    }else{
        [self clearNullView];
        self.navigationItem.rightBarButtonItem = self.editItem;
        
    }
    [self.mDelFooterV resetStatus];
    [self updateSelectedCount];
    [self.tableDelegate loadData:^NSDictionary *{
        return self.originDic;
    }];
    [self.gTableView reloadData];
    //    [self updateTableView];
}


- (void)parseForDic
{
    [self.originDic removeAllObjects];
    NSMutableArray * curArray = [NSMutableArray new];
    for (WVRSectionModel* sectionModel in self.mOriginArray) {
        if (sectionModel.itemModels.count==0) {
            [curArray addObject:sectionModel];
        }
    }
    [self.mOriginArray removeObjectsInArray:curArray];
    for (WVRSectionModel* sectionModel in self.mOriginArray) {
        NSInteger index = [self.mOriginArray indexOfObject:sectionModel];
        self.originDic[@(index)] = [self getSectionInfo:sectionModel];
    }
    
}

-(SQTableViewSectionInfo *)getSectionInfo:(WVRSectionModel*)sectionModel
{
    
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    
    return sectionInfo;
    
}

-(void)updateSelectedCount
{
    NSArray* indexPaths = [self.gTableView indexPathsForSelectedRows];
    NSInteger totalCount = 0;
    for (WVRSectionModel* sectionModel in self.mOriginArray) {
        totalCount += sectionModel.itemModels.count;
    }
    NSString * title = [NSString stringWithFormat:@"删除（%d/%d）",(int)indexPaths.count,(int)totalCount];
    if(indexPaths.count == totalCount){
        [self.mDelFooterV updateSelectStatus:YES];
    }else{
        [self.mDelFooterV updateSelectStatus:NO];
    }
    [self.mDelFooterV updateDelTitle:title];
}


- (BOOL)deleteItemBlock:(NSMutableArray*)cellInfos indexPath:(NSIndexPath*)indexPath
{
    
    return NO;
}

- (void)multiDelete:(NSArray*)codes
{
    
}


- (void)showArrNullView:(NSString*)title icon:(NSString*)icon
{
    if (!self.mNullViewCellCach) {
        self.mNullViewCellCach = [[WVRNullCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
        [self.mNullViewCellCach resetImageToCenter];
        [self.mNullViewCellCach setTint:title];
        [self.mNullViewCellCach setImageIcon:icon];
    }
    [self.view addSubview:self.mNullViewCellCach];
}

- (void)clearNullView
{
    [self.mNullViewCellCach removeFromSuperview];
}


-(void)loadDeleteFooterView {
    
    
    [self.mDelFooterV resetStatus];
    [self updateSelectedCount];
    [self.mDelFooterV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_DELVIEW);
    }];
    
}

-(void)removeDeleteFooterView
{
    [self.mDelFooterV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
}

-(void)didSelectAllCell:(BOOL)selected
{
    //    self.selectAll = selected;
    for (int section=0 ; section < [self.gTableView numberOfSections]; section++) {
        //        if ([self.tableView numberOfSections]>0&&[self.tableView numberOfRowsInSection:0]) {
        if (selected) {
            for (int i = 0; i < [self.gTableView numberOfRowsInSection:section]; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
                
                [self.gTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }else{
            for (int i = 0; i < [self.gTableView numberOfRowsInSection:section]; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
                
                [self.gTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        
        //        }
    }
    [self updateSelectedCount];
}

-(void)alertForMutilDel
{
    if (self.gTableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSArray *indexPaths = [self.gTableView indexPathsForSelectedRows];
        if (indexPaths.count==0) {
            return;
        }
        kWeakSelf(self);
        [UIAlertController alertTitle:@"确定要删除吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            [weakself doMultiDelete];
        } cancleHandler:^(UIAlertAction *action) {
            
        }  viewController:self];
    }
}

@end
