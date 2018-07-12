//
//  WVRSettingsViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/14/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSettingsViewController.h"
#import "WVRSettingTableViewCell.h"
//#import "WVRAboutUsVC.h"
#import "WVRUserModel.h"
#import "WVRAccountAlertView.h"

#import "WVRServerSegmentCell.h"
#import "SQLogManagerController.h"
#import "WVRMediator+AccountActions.h"

#define __CELL_KEY      @"WVRSettingTableViewCell"

@interface WVRSettingsViewController ()<UITableViewDelegate, UITableViewDataSource, WVRAccountAlertViewDelegate>

@property (nonatomic, strong) NSArray *itemViewArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WVRSettingTableViewCell *currentCell;

@property (nonatomic, strong) WVRAccountAlertView *accountAlertView;

@property (nonatomic, strong) UIButton *logoutBtn;

@property (nonatomic) WVRServerSegmentCellInfo * segCellInfo;

@property (nonatomic) WVRSettingTableViewCell * cacheCell;

@end


@implementation WVRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSelf];
    [self allocSubviews];
    [self configSubviews];
    [self positionSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _logoutBtn.hidden = ![WVRUserModel sharedInstance].isLogined;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.backDelegate respondsToSelector:@selector(backForResult:resultCode:)]) {
        [self.backDelegate backForResult:nil resultCode:0];
    }
}
- (void)configSelf {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"设置";
}

- (void)allocSubviews {
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cacheSize = [self getCacheSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.cacheCell updateRightLabel:cacheSize];
        });
    });
    
    self.cacheCell =  [self cellWithLeft:@"清除缓存" right:@"计算中..." style:WVRSettingTableViewCellNull];
    NSMutableArray *muArr =
    [NSMutableArray arrayWithObjects:
     self.cacheCell,
     [self cellWithLeft:@"允许在2G/3G/4G环境下加载缓存" right:@"" style:WVRSettingTableViewCellSwith],
     [self cellWithLeft:@"设置默认清晰度" right:@"" style:WVRSettingTableViewCellSegment],
//     [self cellWithLeft:@"关于微鲸VR" right:@"" style:WVRSettingTableViewCellGoin],
     nil];
    
#if (kAppEnvironmentTest == 1)
    [muArr addObject:
     [self cellWithLeft:@"log管理" right:@"" style:WVRSettingTableViewCellGoin]];
    [muArr addObject:VIEW_WITH_NIB(NSStringFromClass([WVRServerSegmentCell class]))];
#endif
    
    /* Cells */
    _itemViewArray = muArr.copy;
    
    /* Table View */
    _tableView = [[UITableView alloc] init];
    
//    _logoutBtn = [[UIButton alloc] init];
    
    _accountAlertView = [[WVRAccountAlertView alloc] init];
    [_accountAlertView setEnableBgTouchDisappear:YES];
    [_accountAlertView setDelegate:self];
    
#if (kAppEnvironmentTest == 1)
    
    self.segCellInfo = [[WVRServerSegmentCellInfo alloc] init];
    self.segCellInfo.onLineBlock = ^{
        [WVRUserModel sharedInstance].isTest = NO;
        SQToastInKeyWindow(@"已切换到正式服");
        [weakself restartApp];
    };
    self.segCellInfo.onTestBlock = ^{
        [WVRUserModel sharedInstance].isTest = YES;
        SQToastInKeyWindow(@"已切换到测试服");
        [weakself restartApp];
    };
#endif
}

- (void)restartApp {
//    // 打包出来给测试的时候才强制重启
//#ifdef __OPTIMIZE__
//    [UIAlertController alertMesasge:@"App将退出，请再次打开" confirmHandler:^(UIAlertAction *action) {
//        exit(0);
//    } viewController:self];
//#endif
}

- (void)configSubviews
{
    /* Table View */
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView registerClass:[WVRSettingTableViewCell class] forCellReuseIdentifier:__CELL_KEY];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [self.view addSubview:_tableView];
    
//    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [_logoutBtn.titleLabel setFont:kFontFitForSize(15)];
////    [_logoutBtn setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
////    [_logoutBtn setImage:[UIImage imageNamed:@"logout_press"] forState:UIControlStateHighlighted];
//    [_logoutBtn setBackgroundImageWithColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//    [_logoutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_logoutBtn];
    
#if (kAppEnvironmentTest == 1)
    
    // BI switch
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[ @"BI关闭", @"BI打开" ]];
    
    segment.selectedSegmentIndex = [WVRUserModel sharedInstance].isBIOpen;
    segment.bottomX = self.view.width - 15;
    segment.bottomY = self.view.height - 15;
    
    [segment addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
#endif
}

- (void)positionSubviews
{
    CGRect tmpRect = CGRectZero;
    
    tmpRect = self.view.bounds;
    [_tableView setFrame:tmpRect];
    
    tmpRect = [self.view centerRectInSubviewWithWidth:583/2 height:94/2 toBottom:85];
    _logoutBtn.frame = tmpRect;
}

- (void)layoutSubviews
{
    [self positionSubviews];
}

- (WVRSettingTableViewCell *)cellWithLeft:(NSString *) left
                                    right:(NSString *) right
                                    style:(WVRSettingTableViewCellStyle) style
{
    WVRSettingTableViewCell *cell = [[WVRSettingTableViewCell alloc] init];
    
    [cell updateLeftLabel:left];
    [cell updateRightLabel:right];
    [cell updateWithViewStyle:style];
    
    return cell;
}

#pragma mark - action

- (void)segmentedAction:(UISegmentedControl *)sender {
    
    [[WVRUserModel sharedInstance] setIsBIOpen:sender.selectedSegmentIndex];
}

// change
- (void)clearCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_currentCell updateRightLabel:@"0MB"];
            [UIAlertController alertMessage:@"清除缓存成功" viewController:self.view.window.rootViewController];
        });
    });
}

- (NSString *)getCacheSize {
    
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    return [NSString stringWithFormat:@"%.2fMB", (double)size/1024/1024];
}

- (void)logOut {
    
    [_accountAlertView setTitle:@"是否要退出登录？"];
    [_accountAlertView showOnView:self.view];
}

- (void)requestFaild:(NSString *)errorStr {
    
    [self showMessageToWindow:errorStr];
}

#pragma mark - WVRAccountAlertViewDelegate

- (void)ensureView:(WVRAccountAlertView *)ensureView buttonDidClickedAtIndex:(NSInteger)index {
    
    [_accountAlertView disappearHandle];
    
    if (0 == index) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_CLEAR_REWARD_DOT object:nil];
        [[WVRMediator sharedInstance] WVRMediator_Logout:nil];
        _logoutBtn.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } else if (1 == index) {
        // 取消
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
        {
            _currentCell = (WVRSettingTableViewCell*)_itemViewArray[0];
            [self clearCache];
        }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
        {
            SQLogManagerController *logVC = [[SQLogManagerController alloc] init];
            [self.navigationController pushViewController:logVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row > _itemViewArray.count) {
        return [[UITableViewCell alloc] init];
    } else {
        UITableViewCell * cell = _itemViewArray[indexPath.row];

#if (kAppEnvironmentTest == 1)
        if (indexPath.row == _itemViewArray.count - 1) {
            [(WVRServerSegmentCell *)cell fillData:self.segCellInfo];
        }
#endif
        return cell;
    }
}

@end
