//
//  WVRSearchView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSearchView.h"
#import "WVRNullTableViewCell.h"
#import "WVRClearTableViewCell.h"
#import "WVRSearchHistoryTableViewCell.h"
//#import "WVRSearchResultsFor3DTableViewCell.h"

#import "WVRSearchBar.h"
#import "WVRSortItemView.h"
#import "WVRVideoDetailVC.h"
#import "WVRWasuDetailVC.h"
#import "SQRefreshHeader.h"
#import "WVRSearchCell.h"

#import "WVRGotoNextTool.h"

#define __NULL_CELL_KEY                          @"WVRNullTableViewCell"
#define __CLEAR_CELL_KEY                         @"WVRClearTableViewCell"
#define __CELL_KEY                               @"SearchHistoryTableViewCell"
#define __SEARCH_RSULTS_FOR_3D_CELL_KEY          @"WVRSearchCell"


@interface WVRSearchView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WVRSearchBarDelegate, WVRClearTableViewCellDelegate, WVRSortItemViewDelegate>

@property (nonatomic, strong) NSString *currentKeyword;

@property (nonatomic, strong) WVRSearchBar *searchTopBar;

@end


@implementation WVRSearchView

#pragma mark - init configuration

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)configSelf {
        
    _resultsIsNull = NO;
    _isShow3DResult = NO;
    _searchHistoryArray = [NSMutableArray arrayWithCapacity:10];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchKeyWord"];
    [_searchHistoryArray addObjectsFromArray:array];
}

- (void)allocSubviews {
        
    _searchTopBar = [[WVRSearchBar alloc] init];
//    _searchTopBar.backgroundColor = [UIColor redColor];
    _searchTopBar.delegate = self;
    
    _tableView = [[UITableView alloc] init];
    
    _searchResultsView = [[WVRSortItemView alloc] init];
    _searchResultsView.realDelegate = self;
}

- (void)setSearchBarHolder:(NSString*)holderStr {
        
    [_searchTopBar setPlaceholder:holderStr];
}

- (void)configSubviews {
        
    /* Table View */
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView registerClass:[WVRNullTableViewCell class] forCellReuseIdentifier:__NULL_CELL_KEY];
    [_tableView registerClass:[WVRClearTableViewCell class] forCellReuseIdentifier:__CLEAR_CELL_KEY];
    [_tableView registerClass:[WVRSearchHistoryTableViewCell class] forCellReuseIdentifier:__CELL_KEY];
//    [_tableView registerClass:[WVRCollectionCell class] forCellReuseIdentifier:__SEARCH_RSULTS_FOR_3D_CELL_KEY];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WVRSearchCell class]) bundle:nil] forCellReuseIdentifier:__SEARCH_RSULTS_FOR_3D_CELL_KEY];

    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    _tableView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    _tableView.mj_header.hidden = YES;
    
    [_searchResultsView setCellStyle:WVRItemCellStyleNormal];
    _searchResultsView.realDelegate = self;
    _searchResultsView.hidden = YES;
    
    [self addSubview:_searchTopBar];
    [self addSubview:_tableView];
    [self addSubview:_searchResultsView];
}

- (void)positionSubvies {
        
    CGRect tmpRect = CGRectZero;
    
    tmpRect = [self centerRectInSubviewWithWidth:self.width height:50 toTop:20];
    _searchTopBar.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:self.width height:self.height - kNavBarHeight toTop:_searchTopBar.bottom];
    [_tableView setFrame:tmpRect];
    [_searchResultsView setFrame:tmpRect];
}

- (void)layoutSubviews {
        
    [self positionSubvies];
}

#pragma mark - private func

- (UICollectionView *)getSearchResultsCollectionView {
        
    return _searchResultsView.collectionView;
}

- (void)showKeyboard {
    
    [_searchTopBar showKeyboard];
}

#pragma mark - WVRSortItemViewDelegate

- (void)sortItemView:(WVRSortItemView *)itemView didSelectItem:(NSIndexPath *)indexPath {
        
    WVRSortItemModel *model = (WVRSortItemModel *)_searchResultsView.dataArray[indexPath.row];
    
    WVRItemModel* itemModel = [WVRItemModel new];
    itemModel.name = model.title;
    itemModel.thubImageUrl = model.image;
    itemModel.intrDesc = model.desc;
    itemModel.videoType = model.videoType;
    itemModel.programType = model.programType;
    itemModel.linkArrangeValue = model.sid;
    itemModel.linkArrangeType = model.isDrama ? nil : LINKARRANGETYPE_PROGRAM;
    
    UIViewController *currentVC = self.wvr_viewController;
    [WVRGotoNextTool gotoNextVC:itemModel nav:currentVC.navigationController];
}

- (void)sortItemViewPulldownRefreshData:(WVRSortItemView *)itemView {
    
    [_searchResultsView endRefresh];
}

- (void)sortItemViewPullupLoadMoreData:(WVRSortItemView *)itemView {
    
    [_searchResultsView endRefresh];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    CGFloat height;
    if (_resultsIsNull)
    {
        height = self.height - kNavBarHeight;
        
    } else if (_isShow3DResult) {
        
        height = fitToWidth(95);//adaptToWidth(189);
        
    } else {
        
        height = adaptToWidth(42.5);
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSInteger numOfRows = (!_isShow3DResult && _searchHistoryArray.count > 0) ? [_tableView numberOfRowsInSection:0] + 1 : [_tableView numberOfRowsInSection:0];
    if (_resultsIsNull || indexPath.row >= numOfRows) {
        return;
    }
    
    if (_isShow3DResult) {
        
        [WVRTrackEventMapping trackingResearch:@"result"];
        
        WVRSortItemModel *model = (WVRSortItemModel *)_searchResultsFor3DArray[indexPath.row];
        
        WVRItemModel* itemModel = [WVRItemModel new];
        itemModel.name = model.title;
        itemModel.thubImageUrl = model.image;
        itemModel.intrDesc = model.desc;
        itemModel.videoType = model.videoType;
        itemModel.programType = model.programType;
        itemModel.linkArrangeValue = model.sid;
        itemModel.linkArrangeType = model.isDrama ? nil : LINKARRANGETYPE_PROGRAM;
        
        UIViewController *currentVC = self.wvr_viewController;
        [WVRGotoNextTool gotoNextVC:itemModel nav:currentVC.navigationController];
    } else {
        
        if (0 == indexPath.row) { return; }
        
        [WVRTrackEventMapping trackingResearch:@"history"];
        
        NSString *keyword = (NSString *)_searchHistoryArray[indexPath.row - 1];
        [_searchTopBar setSearchText:keyword];
         [self searchButtonClickedWithKeyWord:keyword];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClickedWithKeyWord:)]) {
//
//            [self.delegate searchButtonClickedWithKeyWord:keyword];
//        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    NSInteger rowNum;
    
    if (!_resultsIsNull && !_isShow3DResult) {
        rowNum = (0 == _searchHistoryArray.count) ? 0 : _searchHistoryArray.count + 1;
    } else if(_isShow3DResult) {
        rowNum = _searchResultsFor3DArray.count;
    } else {
        rowNum = 1;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = nil;
    NSInteger totalNum = (!_resultsIsNull && !_isShow3DResult && (0 != _searchHistoryArray.count)) ? [_tableView numberOfRowsInSection:0] + 1 : [_tableView numberOfRowsInSection:0];
    
    if (indexPath.row >= totalNum) {
        
        cell = [[UITableViewCell alloc] init];
    } else {
        
        if (_resultsIsNull) {
            
            WVRNullTableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier:__NULL_CELL_KEY];
            
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return viewCell;
        }
        
        if (_isShow3DResult) {
            WVRSearchCell *viewCell = [tableView dequeueReusableCellWithIdentifier:__SEARCH_RSULTS_FOR_3D_CELL_KEY];
            WVRSortItemModel * sortItemModel = _searchResultsFor3DArray[indexPath.row];
            WVRSearchCellInfo * info = [WVRSearchCellInfo new];
            info.itemModel = [WVRItemModel new];
            info.itemModel.name = sortItemModel.title;
            info.itemModel.thubImageUrl = sortItemModel.image;
            info.itemModel.intrDesc = sortItemModel.desc;
            info.itemModel.videoType = sortItemModel.videoType;
            info.itemModel.programType = sortItemModel.programType;
            info.itemModel.linkArrangeValue = sortItemModel.sid;
            info.isDrama = sortItemModel.isDrama;
            [viewCell fillData:info];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return viewCell;
        }
        
        if (0 == indexPath.row) {
            
            WVRClearTableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier:__CLEAR_CELL_KEY];
            
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            viewCell.delegate = self;
            cell = viewCell;
        } else {
            
            WVRSearchHistoryTableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier:__CELL_KEY];
            
            NSString *keyword = (NSString *)_searchHistoryArray[indexPath.row -1];
            [viewCell updateKeyword:keyword];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = viewCell;
        }
    }
    
    return cell;
}

#pragma mark - WVRClearTableViewCellDelegate

- (void)clearHistoryKeyword {
        
    [_searchHistoryArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchKeyWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_tableView reloadData];
}

#pragma mark - WVRSearchBarDelegate

- (void)searchButtonClickedWithKeyWord:(NSString *)keyword {
    
    [WVRTrackEventMapping trackingResearch:@"research"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchDataWithKeyWord:)]) {
        
        [self.delegate searchDataWithKeyWord:keyword];
    }
    
//    for (NSString *str in _searchHistoryArray) {
//        if ([str isEqualToString:keyword]) {
//            return;
//        }
//    }
    [_searchHistoryArray removeObject:keyword];
    if (_searchHistoryArray.count >= 10) {
        
        [_searchHistoryArray removeLastObject];
        [_searchHistoryArray insertObject:keyword atIndex:0];
        
    } else {
        
        [_searchHistoryArray insertObject:keyword atIndex:0];
    }
}

- (void)showSearchHistory {
        
    _resultsIsNull = NO;
    [_tableView reloadData];
}

#pragma mark - action

- (void)pulldownRefreshData {
    [self searchButtonClickedWithKeyWord:[self.searchTopBar getCurText]];
//    [self.tableView.mj_header endRefreshing];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
