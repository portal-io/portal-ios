//
//  WVRRewardController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRRewardController.h"
#import "WVRRewardHeaderV.h"
#import "WVRRewardSectionHeader.h"
#import "WVRRewardCell.h"
#import "WVREditAddressController.h"
#import "WVRRewardViewModel.h"
#import "WVRVirtualRewardCell.h"
#import "WVRVirtualCardRewardCell.h"
#import "WVRNavigationController.h"
#import "WVRTableView.h"

#import "WVRMediator+UnityActions.h"

#import "WVREditAddressViewModel.h"
#import "WVRAddressModel.h"

@interface WVRRewardController ()<BaseBackForResultDelegate>

@property (nonatomic, strong) NSMutableDictionary * originDic;
@property (nonatomic, strong) SQTableViewDelegate * gDelegate;

@property (nonatomic) WVRRewardHeaderV * mHeadV;
@property (nonatomic) WVRRewardHeaderVInfo* mHeadVInfo;
@property (nonatomic) WVRAddressModel* mAddressModel;

@property (nonatomic, strong) WVREditAddressViewModel * gEditAddressViewModel;
@property (nonatomic, strong) WVRRewardViewModel * gRewardViewModel;

@end


@implementation WVRRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showCancleLeftBtn];
    self.hidesBottomBarWhenPushed = YES;
    self.gTableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = k_Color11;
    self.mAddressModel = [WVRAddressModel new];
    [self installRAC];
    [self requestInfo];
    [self showCancleLeftBtn];
//    [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationPortrait];
}

-(void)showCancleLeftBtn
{
    if ([self presentingViewController]) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 44);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (_isFormUnity) {
        WVRNavigationController *nav = (WVRNavigationController *)self.navigationController;
        nav.gestureInValid = YES;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.getEmptyView.frame = CGRectMake(0, kNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavBarHeight);
    self.mHeadV.frame = CGRectMake(0, kNavBarHeight, self.view.width, fitToWidth(41.0f));
    self.gTableView.frame = CGRectMake(0, self.mHeadV.bottomY, self.view.width, SCREEN_HEIGHT-self.mHeadV.bottomY);
    
}

-(WVREditAddressViewModel *)gEditAddressViewModel
{
    if (!_gEditAddressViewModel) {
        _gEditAddressViewModel = [[WVREditAddressViewModel alloc] init];
    }
    return _gEditAddressViewModel;
}

-(WVRRewardViewModel *)gRewardViewModel
{
    if (!_gRewardViewModel) {
        _gRewardViewModel = [[WVRRewardViewModel alloc] init];
    }
    return _gRewardViewModel;
}

-(SQTableViewDelegate *)gDelegate
{
    if (!_gDelegate) {
        _gDelegate = [[SQTableViewDelegate alloc] init];
    }
    return _gDelegate;
}

-(NSMutableDictionary *)originDic
{
    if (!_originDic) {
        _originDic = [[NSMutableDictionary alloc] init];
    }
    return _originDic;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gEditAddressViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self getAddressSuccessBlock:x];
    }];
    [[self.gEditAddressViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        SQHideProgress;
        SQToastInKeyWindow(kNoNetAlert);
    }];
    
    [[self.gRewardViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpMyRewardSuccessBlock:x];
    }];
    [[self.gRewardViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        SQHideProgress;
        [self.getEmptyView showNetErrorVWithreloadBlock:^{
            [self requestInfo];
        }];
    }];
}

-(void)getAddressSuccessBlock:(WVRAddressModel*)model
{
    SQHideProgress;
    self.mAddressModel = model;
    [self updateHeadV];
}

- (void)initTitleBar {
    [super initTitleBar];
    
    self.title = @"我的奖品";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


- (void)back {
    
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    if ([self presentingViewController]) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestInfo {
    [super requestInfo];
    
    kWeakSelf(self);
    if (![WVRUserModel sharedInstance].isLogined) {
        [weakself.getEmptyView showNullViewWithTitle:@"你还没抽中任何奖品\n请再接再厉～" icon:@"icon_no_reward" withreloadBlock:^{
        }];
        return;
    }
    SQShowProgress;
    [[self.gRewardViewModel getRewardCmd]execute:nil];
    [[self.gEditAddressViewModel getGetAddressCmd] execute:nil];
}

- (void)httpMyRewardSuccessBlock:(WVRRewardVCModel *)vcModel {
    SQHideProgress;
//    [self initHeadV];
    [self initSubTabelV];
    if (vcModel.sectionRewards.count == 0) {
        [self.getEmptyView showNullViewWithTitle:@"你还没抽中任何奖品\n请再接再厉～" icon:@"icon_no_reward" withreloadBlock:^{
            
        }];
        self.gTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self.getEmptyView setHidden:YES];
        self.gTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSArray<WVRRewardSectionModel*>* sectionModels = vcModel.sectionRewards;
        for (WVRRewardSectionModel* sectionModel in sectionModels) {
            NSInteger index = [sectionModels indexOfObject:sectionModel];
            self.originDic[@(index)] = [self getDefaultSctionInfo:sectionModel];
        }
        [self.gDelegate loadData:^NSDictionary *{
            return self.originDic;
        }];
        [self.gTableView reloadData];
    }
}


- (void)initSubTabelV {
    
//        self.gTableView = [[WVRTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.gTableView.y = self.mHeadV.bottomY;
        self.gTableView.height -= self.mHeadV.bottomY;
        self.gTableView.backgroundColor = [UIColor clearColor];
    self.gTableView.dataSource = self.gDelegate;
    self.gTableView.delegate = self.gDelegate;
//        [self initgTableView];
//    }
    [self.view addSubview:self.gTableView];
}

-(BOOL)isEmptyAddress
{
    BOOL isEmpty = self.mAddressModel.province.length==0
                    &&self.mAddressModel.city.length==0
                    &&self.mAddressModel.county.length==0
                    &&self.mAddressModel.address.length==0;
    return isEmpty;
}
- (void)initHeadV {
    
    kWeakSelf(self);
    if (!self.mHeadV) {
        WVRRewardHeaderV * headV = (WVRRewardHeaderV*)VIEW_WITH_NIB(NSStringFromClass([WVRRewardHeaderV class]));
        WVRRewardHeaderVInfo* vInfo = [WVRRewardHeaderVInfo new];
        vInfo.changeBlock = ^{
            WVREditAddressController * vc = [[WVREditAddressController alloc] init];
            vc.createArgs = [weakself.mAddressModel copyNewModel];
            vc.backDelegate = weakself;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        [headV fillData:vInfo];
        headV.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, fitToWidth(41.0f));
        [self.view addSubview:headV];
        self.mHeadV = headV;
        self.mHeadVInfo = vInfo;
    }
}

-(NSString*)formatAddress
{
    NSString * cur = @"当前地址：";
    if (self.mAddressModel.province.length>0) {
        cur = [[cur stringByAppendingString:self.mAddressModel.province] stringByAppendingString:@" "];
    }
    if (self.mAddressModel.city.length>0) {
        cur = [[cur stringByAppendingString:self.mAddressModel.city] stringByAppendingString:@" "];

    }
    if (self.mAddressModel.county.length>0) {
        cur = [[cur stringByAppendingString:self.mAddressModel.county] stringByAppendingString:@" "];

    }
    if (self.mAddressModel.address.length>0) {
        cur = [[cur stringByAppendingString:self.mAddressModel.address] stringByAppendingString:@" "];
        
    }
    return cur;
}

- (void)updateHeadV {
    if (!self.mHeadV) {
        [self initHeadV];
    }
    NSLog(@"address:%@",self.mAddressModel.address);
    if([self isEmptyAddress]){
        self.mHeadVInfo.address = @"当前没有地址";
        self.mHeadVInfo.operateTitle = @"添加";
    }else{
        self.mHeadVInfo.address = [self formatAddress];
        self.mHeadVInfo.operateTitle = @"修改";
    }
    
    [self.mHeadV fillData:self.mHeadVInfo];
}

- (SQTableViewSectionInfo *)getDefaultSctionInfo:(WVRRewardSectionModel *)sectionModel {
    
    SQTableViewSectionInfo* sectionInfo = [SQTableViewSectionInfo new];
    WVRRewardSectionHeaderInfo * headerInfo = [WVRRewardSectionHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRRewardSectionHeader class]);
    headerInfo.title = sectionModel.formatDateKey;
    headerInfo.cellHeight = fitToWidth(75.0/2.0f);
    sectionInfo.headViewInfo = headerInfo;
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRRewardModel* cur in sectionModel.rewards) {
        [self addCellInfoTo:cellInfos withRewardModel:cur];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (void)addCellInfoTo:(NSMutableArray*)cellInfos withRewardModel:(WVRRewardModel*)cur {
    
    if (cur.rewardType == WVRRewardModelTypeDefault||cur.rewardType== WVRRewardModelTypeVirtualCardNoCopy) {
        WVRRewardCellInfo * cellInfo = [WVRRewardCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRRewardCell class]);
        cellInfo.cellHeight = fitToWidth(138.0f);
        cellInfo.rewardModel = cur;
        [cellInfos addObject:cellInfo];
    }else if(cur.rewardType == WVRRewardModelTypeCodeEXCode){
        WVRVirtualRewardCellInfo * cellInfo = [WVRVirtualRewardCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRVirtualRewardCell class]);
        cellInfo.cellHeight = fitToWidth(138.0f);
        cellInfo.rewardModel = cur;
        kWeakSelf(cellInfo);
        kWeakSelf(self);
        cellInfo.copyBlock = ^{
            [weakself copyBlock:weakcellInfo];
        };
        [cellInfos addObject:cellInfo];
    }else if (cur.rewardType == WVRRewardModelTypeVirtualCard){
        WVRVirtualCardRewardCellInfo * cellInfo = [WVRVirtualCardRewardCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRVirtualCardRewardCell class]);
        cellInfo.cellHeight = fitToWidth(138.0f);
        cellInfo.rewardModel = cur;
        [cellInfos addObject:cellInfo];
    }
}

- (void)copyBlock:(WVRVirtualRewardCellInfo *)cellInfo {
    
    UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
    
    pastboad.string = cellInfo.rewardModel.rewardInfo.length>0? cellInfo.rewardModel.rewardInfo:@"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"复制成功"
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)backForResult:(id)info resultCode:(NSInteger)resultCode {
    
    WVRAddressModel* backModel = info;
    self.mAddressModel = backModel;
    
    [self updateHeadV];
}

#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif 
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

@end
