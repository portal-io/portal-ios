//
//  WVRSearchViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSearchViewController.h"
#import "WVRSearchView.h"
#import "WVRSortItemModel.h"
#import "WVRSortItemView.h"
#import "WVRHttpSearchModel.h"
#import "SQRefreshHeader.h"
#import "WVRSearchViewModel.h"

@interface WVRSearchViewController ()<WVRSearchViewDelegate>

@property (nonatomic, strong) WVRSearchView *contentView;
@property (nonatomic, strong) WVRSearchViewModel * gSearchViewModel;

@end


@implementation WVRSearchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self installRAC];
    [self configSubviews];
    [self.keyTool addKeyHandleWithOwner:_contentView];
    [_contentView showKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view.window resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSUserDefaults standardUserDefaults] setObject:_contentView.searchHistoryArray forKey:@"searchKeyWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(WVRSearchViewModel *)gSearchViewModel
{
    if (!_gSearchViewModel) {
        _gSearchViewModel = [[WVRSearchViewModel alloc] init];
    }
    return _gSearchViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gSearchViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.contentView.tableView.mj_header endRefreshing];
        [self parseHttpData:x];
    }];
    [[self.gSearchViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self.contentView.tableView.mj_header endRefreshing];
        [self requestFaild:x];
    }];
}

- (void)configSubviews {
    
    _contentView = [[WVRSearchView alloc] init];
    _contentView.frame = self.view.bounds;
    _contentView.delegate = self;
    [_contentView setSearchBarHolder:@"输入搜索文字"];
    [self.view addSubview:_contentView];
}

- (NSArray *)getModelArrayFromDicArray:(NSArray *)array
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (WVRHttpSimpleProgramModel *cur in array) {
        
        WVRSortItemModel *model = [[WVRSortItemModel alloc] init];
        model.title = cur.display_name;
        model.desc = cur.desc;
        model.sid = cur.code;
        model.image = cur.big_pic;
        model.resource_code = cur.code;
        
        model.director = cur.director ? @[cur.director] : @[];
        model.actor = [self parseActors:cur.actors];
        model.tags = cur.tags;
        model.videoType = cur.video_type; // (WVRVideoStyleVR == _videoStyle) ? VIDEO_TYPE_VR : VIDEO_TYPE_3D;
        model.area = cur.area;
        model.programType = cur.program_type;
        model.isDrama = [cur.program_type isEqualToString:PROGRAMTYPE_DRAMA];
        
        [modelArray addObject:model];
    }
    
    return [modelArray copy];
}

- (NSString *)parseActors:(NSString *)actorStr
{
    NSString * str = @"";
    NSArray* arr = [actorStr componentsSeparatedByString:@";"];
    for (NSString* cur in arr) {
        str = [str stringByAppendingString:cur];
    }
    return str;
}

#pragma mark - WVRSearchViewDelegate

- (void)searchDataWithKeyWord:(NSString *)keyword {
    
    [self http_recommendPageWithCode:keyword];
    
    [self.view endEditing:YES];
}

#pragma mark - http movie

- (void)http_recommendPageWithCode:(NSString *)keyWord {
    
    SQShowProgress;
    self.gSearchViewModel.keyWord = keyWord;

    [[self.gSearchViewModel getSearchCmd] execute:nil];
}

- (void)requestFaild:(NSString *)errorStr {
    [self hideProgress];
    [self showToast:kNoNetAlert];
}

- (void)parseHttpData:(WVRHttpSearchModel *)data {
    [self hideProgress];
    NSArray *modelArray = [self getModelArrayFromDicArray:[data program]];
    
    if (modelArray.count > 0) {
        
        _contentView.resultsIsNull = NO;
            _contentView.searchResultsView.hidden = YES;
            
            _contentView.isShow3DResult = YES;
            _contentView.searchResultsFor3DArray = modelArray;
            _contentView.tableView.mj_header.hidden = NO;
            _contentView.tableView.hidden = NO;
            [_contentView.tableView reloadData];
//        }
    } else {
        _contentView.isShow3DResult = NO;
        
        _contentView.tableView.hidden = NO;
        _contentView.tableView.mj_header.hidden = YES;
        _contentView.searchResultsView.hidden = YES;
        _contentView.resultsIsNull = YES;
        [_contentView.tableView reloadData];
    }
}

@end
