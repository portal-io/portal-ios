//
//  WVRAddAddressController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVREditAddressController.h"
#import "WVRAddressInputCell.h"
#import "WVRAddressBtnCell.h"
#import "SNLoadPlaceTool.h"
#import "WVRAddressPickerV.h"
#import "WVRUpdateAdressHandle.h"

#import "WVRAddressModel.h"

#define titelKey (@"title")
#define holderKey (@"holder")
#define contentKey (@"content")
#define notEnable (@"notEnable")
#define nextBlock (@"nextBlock")
#define contentBlock (@"contentBlock")
#define notMust (@"notMust")


@interface WVREditAddressController ()

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;
@property (nonatomic, strong) SQTableViewDelegate * gTableViewDelegate;

@property (nonatomic) SNProvinceInfo * mProvinceInfo;
@property (nonatomic) SNCityInfo * mCityInfo;
@property (nonatomic) SNCountyInfo * mCountyInfo;
@property (nonatomic) WVRAddressPickerV* mPickerV;
@property (nonatomic) WVRAddressPickerVInfo * mPickerVInfo;

@property (nonatomic) WVRAddressModel* mAddressModel;

@property (nonatomic, weak) WVRAddressBtnCell *btnCell;

@property (nonatomic, strong) WVRUpdateAdressHandle *gUpdateaddressHandle;

@end


@implementation WVREditAddressController
@synthesize gTableView = _gTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObservers];
    [self setupRAC];
    self.gTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.keyTool addKeyHandleWithOwner:self.gTableView];
    [self.view addSubview:self.gTableView];
    
    self.mAddressModel = self.createArgs;
    [self initInfos];
    [self initPickerV];
    
    [self requestInfo];
}

- (UITableView *)gTableView {
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _gTableView.y = kNavBarHeight;
        _gTableView.height = _gTableView.height-kNavBarHeight;
    }
    return _gTableView;
}

-(WVRUpdateAdressHandle *)gUpdateaddressHandle
{
    if (!_gUpdateaddressHandle) {
        _gUpdateaddressHandle = [[WVRUpdateAdressHandle alloc] init];
    }
    return _gUpdateaddressHandle;
}

-(NSMutableDictionary *)gOriginDic
{
    if (!_gOriginDic) {
        _gOriginDic = [[NSMutableDictionary alloc] init];
    }
    return _gOriginDic;
}

-(SQTableViewDelegate *)gTableViewDelegate
{
    if (!_gTableViewDelegate) {
        _gTableViewDelegate = [[SQTableViewDelegate alloc] init];
    }
    return _gTableViewDelegate;
}

- (void)setupRAC {
    
    @weakify(self);
    [[self.gUpdateaddressHandle gSuccessSignal] subscribeNext:^(WVRHttpAddressModel*  _Nullable x) {
        @strongify(self);
        [self updateAddressSuccess];
    }];
    
    [[self.gUpdateaddressHandle gFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        
        SQToastInKeyWindow(x.errorMsg);
        [self hideProgress];
    }];
}

- (void)updateAddressSuccess {
    
    SQToastInKeyWindow(@"地址修改成功");
    [self hideProgress];
    self.backArgs = self.mAddressModel;
    if ([self.backDelegate respondsToSelector:@selector(backForResult:resultCode:)]) {
        [self.backDelegate backForResult:self.backArgs resultCode:self.backCode];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.mPickerV removeFromSuperview];
}

- (void)initInfos {
    
    if (self.mAddressModel.province) {
        self.mProvinceInfo = [SNLoadPlaceTool searchProviceData:self.mAddressModel.province];
        self.mCityInfo = [SNLoadPlaceTool searchCityData:self.mAddressModel.city];
    }
}

- (void)initPickerV {
    
    if (!self.mPickerV) {
        WVRAddressPickerV* pickerV = (WVRAddressPickerV *)VIEW_WITH_NIB(NSStringFromClass([WVRAddressPickerV class]));
        pickerV.frame = CGRectMake(0, SCREEN_HEIGHT-fitToWidth(260), SCREEN_WIDTH, fitToWidth(260));
        [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
        pickerV.hidden = YES;
        self.mPickerV.backgroundColor = [UIColor redColor];
        self.mPickerV = pickerV;
        self.mPickerVInfo = [WVRAddressPickerVInfo new];
    }
}

- (void)initTitleBar {
    
    [super initTitleBar];
    self.title = @"修改地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (WVRAddressBtnCell *)btnCell {
    if (!_btnCell) {
        
        for (UITableViewCell *cell in [self.gTableView visibleCells]) {
            if ([cell isKindOfClass:[WVRAddressBtnCell class]]) {
                _btnCell = (WVRAddressBtnCell *)cell;
                break;
            }
        }
    }
    return _btnCell;
}

#pragma mark - action

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestInfo {
    
    [super requestInfo];
    self.gOriginDic[@(0)] = [self getDefaultSctionInfo:@"0"];
    @weakify(self);
    [self.gTableViewDelegate loadData:^NSDictionary *{
        @strongify(self);
        return self.gOriginDic;
    }];
    self.gTableView.dataSource = self.gTableViewDelegate;
    self.gTableView.delegate = self.gTableViewDelegate;
    [self.gTableView reloadData];
    [self addressValueChanged];
}

- (void)reloadData {
    
    [self addressValueChanged];
    self.gOriginDic[@(0)] = [self getDefaultSctionInfo:@"0"];
    @weakify(self);
    [self.gTableViewDelegate loadData:^NSDictionary *{
        @strongify(self);
        return self.gOriginDic;
    }];
    [self.gTableView reloadData];
}

- (SQTableViewSectionInfo *)getDefaultSctionInfo:(NSString *)title {
    
    kWeakSelf(self);
    SQTableViewSectionInfo* sectionInfo = [SQTableViewSectionInfo new];
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (NSDictionary* dic in [self getTitles]) {
        WVRAddressInputCellInfo * cellInfo = [WVRAddressInputCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRAddressInputCell class]);
        cellInfo.cellHeight = fitToWidth(69);
        cellInfo.title = dic[titelKey];
        cellInfo.placeHolder = dic[holderKey];
        cellInfo.content = dic[contentKey];
        cellInfo.tfNotEnable = [dic[notEnable] boolValue];
        cellInfo.gotoNextBlock = dic[nextBlock];
        cellInfo.changeContentBlock = dic[contentBlock];
        cellInfo.isNotMust = [dic[notMust] boolValue];
        [cellInfos addObject:cellInfo];
    }
    
    WVRAddressBtnCellInfo * cellInfo = [WVRAddressBtnCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRAddressBtnCell class]);
    cellInfo.cellHeight = fitToWidth(135);
    cellInfo.commitBlock = ^{
        [weakself.keyTool hideKeyboard];
        if ([weakself checkInputValidAndToast]) {
            [weakself http_updateAddress];
        }
    };
    [cellInfos addObject:cellInfo];
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (NSArray *)getTitles {
    
    kWeakSelf(self);
    
    return @[ @{ titelKey:@"收件人：", holderKey:@"收件人", contentKey:self.mAddressModel.username ? self.mAddressModel.username:@"", notEnable:@(0), nextBlock:^(id args){}, contentBlock:^(NSString *text) {
        weakself.mAddressModel.username = text;
        [weakself addressValueChanged];
    }},
             @{titelKey:@"联系电话：", holderKey:@"联系电话", contentKey:self.mAddressModel.mobile? self.mAddressModel.mobile:@"", notEnable:@(0), nextBlock:^(id args){}, contentBlock:^(NSString*text){
                 weakself.mAddressModel.mobile = text;
                 [weakself addressValueChanged];
             }},
//              @{titelKey:@"所在省：", holderKey:@"所在省", contentKey:self.mAddressModel.province? self.mAddressModel.province:@"", notEnable:@(1),notMust:@(1), nextBlock:^(WVRAddressInputCellInfo* args){
//                 [weakself showProvincePicker:args];
//             }, contentBlock:^(NSString *text) {
//
//                 [weakself addressValueChanged];
//             }},
//             @{titelKey:@"所在市：", holderKey:@"所在市", contentKey:self.mAddressModel.city? self.mAddressModel.city:@"", notEnable:@(1),notMust:@(1), nextBlock:^(WVRAddressInputCellInfo* args) {
//                 [weakself showCityPicker:args];
//             }, contentBlock:^(NSString *text) {
//
//                 [weakself addressValueChanged];
//             }},
//             @{titelKey:@"所在区/县：", holderKey:@"所在区/县", contentKey:self.mAddressModel.county? self.mAddressModel.county:@"", notEnable:@(1),
//                 notMust:@(1),
//                 nextBlock:^(WVRAddressInputCellInfo* args) {
//                 [weakself showCountyPicker:args];
//             }, contentBlock:^(NSString *text) {
//
//                 [weakself addressValueChanged];
//             }},
             @{titelKey:@"详细地址：", holderKey:@"详细地址", contentKey:self.mAddressModel.address? self.mAddressModel.address:@"", notEnable:@(0), nextBlock:^(id args){}, contentBlock:^(NSString *text) {
                 weakself.mAddressModel.address = text;
                 [weakself addressValueChanged];
             }} ];
}


- (void)showProvincePicker:(WVRAddressInputCellInfo *)args {
    
     NSArray<SNProvinceInfo*>* provinceArr = [SNLoadPlaceTool loadLetterArrayForProvince];
    self.mPickerV.hidden = NO;
    NSMutableArray *curArr = [NSMutableArray arrayWithArray:provinceArr];
    SNBasePlaceInfo* titleInfo = [SNBasePlaceInfo new];
    titleInfo.name = @"选择省";
    [curArr insertObject:titleInfo atIndex:0];
    self.mPickerVInfo.pickDataArr = curArr;
    kWeakSelf(self);
    self.mPickerVInfo.completeBlock = ^(SNBasePlaceInfo* info){
        weakself.mProvinceInfo = (SNProvinceInfo*)info;
        args.content = info.name;
        weakself.mAddressModel.province = info.name;
        weakself.mCityInfo = nil;
        weakself.mAddressModel.city = @"";
        weakself.mCountyInfo = nil;
        weakself.mAddressModel.county = @"";
        [weakself reloadData];
        weakself.mPickerV.hidden = YES;
    };
    [self.mPickerV fillData:self.mPickerVInfo];
}

- (void)showCityPicker:(WVRAddressInputCellInfo *)args {
    
    if (self.mProvinceInfo.uuid.length == 0) {
        SQToast(@"请选择省份");
        return;
    }
    NSArray<SNCityInfo*>* provinceArr = [SNLoadPlaceTool loadCityArrayForProvince:self.mProvinceInfo.uuid];
    self.mPickerV.hidden = NO;
    NSMutableArray *curArr = [NSMutableArray arrayWithArray:provinceArr];
    SNBasePlaceInfo* titleInfo = [SNBasePlaceInfo new];
    titleInfo.name = @"选择市";
    [curArr insertObject:titleInfo atIndex:0];
    self.mPickerVInfo.pickDataArr = curArr;
    kWeakSelf(self);
    self.mPickerVInfo.completeBlock = ^(SNBasePlaceInfo* info){
        weakself.mCityInfo = (SNCityInfo*)info;
        args.content = info.name;
        weakself.mAddressModel.city = info.name;
        weakself.mCountyInfo = nil;
        weakself.mAddressModel.county = @"";
        [weakself reloadData];
        weakself.mPickerV.hidden = YES;
    };
    [self.mPickerV fillData:self.mPickerVInfo];
}

- (void)showCountyPicker:(WVRAddressInputCellInfo *)args {
    
    if (self.mCityInfo.uuid.length == 0) {
        SQToast(@"请选择城市");
        return;
    }
    NSArray<SNCountyInfo*>* provinceArr = [SNLoadPlaceTool loadCountyArrayForCity:self.mCityInfo.uuid];
    self.mPickerV.hidden = NO;
    NSMutableArray *curArr = [NSMutableArray arrayWithArray:provinceArr];
    SNBasePlaceInfo* titleInfo = [SNBasePlaceInfo new];
    titleInfo.name = @"选择区/县";
    [curArr insertObject:titleInfo atIndex:0];
    self.mPickerVInfo.pickDataArr = curArr;
    kWeakSelf(self);
    self.mPickerVInfo.completeBlock = ^(SNBasePlaceInfo* info){
        weakself.mCountyInfo = (SNCountyInfo*)info;
        args.content = info.name;
        weakself.mAddressModel.county = info.name;
        [weakself reloadData];
        weakself.mPickerV.hidden = YES;
    };
    [self.mPickerV fillData:self.mPickerVInfo];
}

- (void)addressValueChanged {
    
    BOOL enabel = [self checkInputValid:nil];
    
    [self.btnCell updateBtnStatus:enabel];
}

- (BOOL)checkInputValidAndToast {
    
    NSString *msg = nil;
    
    BOOL enabel = [self checkInputValid:&msg];
    
    SQToast(msg);
    
    return enabel;
}

- (BOOL)checkInputValid:(NSString **)errorMsg {
    
    if (self.mAddressModel.username.length == 0) {
        if (errorMsg) { *errorMsg = @"请填写收件人"; }
        
        return NO;
    }
    if(self.mAddressModel.mobile.length == 0) {
        if (errorMsg) { *errorMsg = @"请填写联系电话"; }
        
        return NO;
    }
//    if (self.mAddressModel.province.length == 0) {
//        if (errorMsg) { *errorMsg = @"请填写省份"; }
//
//        return NO;
//    }
//    if (self.mAddressModel.city.length == 0) {
//        if (errorMsg) { *errorMsg = @"请填写城市"; }
//
//        return NO;
//    }
//    if (self.mAddressModel.county.length == 0) {
//        if (errorMsg) { *errorMsg = @"请填写区县"; }
//
//        return NO;
//    }
    if (self.mAddressModel.address.length == 0) {
        if (errorMsg) { *errorMsg = @"请填写详细地址"; }
        
        return NO;
    }
    return YES;
}

#pragma mark - http updateAddress

- (void)http_updateAddress {
    
    SQShowProgress;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_UpdateAddress_whaleyuid] = [[WVRUserModel sharedInstance] accountId];
    params[kHttpParams_UpdateAddress_username] = self.mAddressModel.username;
    params[kHttpParams_UpdateAddress_mobile] = self.mAddressModel.mobile;
    if(self.mAddressModel.province.length>0){
        params[kHttpParams_UpdateAddress_province] = self.mAddressModel.province;
    }
    if(self.mAddressModel.city.length>0){
        params[kHttpParams_UpdateAddress_city] = self.mAddressModel.city;
    }
    if (self.mAddressModel.county.length>0) {
        params[kHttpParams_UpdateAddress_county] = self.mAddressModel.county;
    }
    params[kHttpParams_UpdateAddress_address] = self.mAddressModel.address;
    
    self.gUpdateaddressHandle.params = params;
    [self.gUpdateaddressHandle.gHttpCmd execute:nil];
}

#pragma mark - Observer
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    CGRect tmpRect = self.view.bounds;
    tmpRect.origin.y = kNavBarHeight;
    tmpRect.size.height = self.view.bounds.size.height - keyboardHeight - kNavBarHeight;
    [self.gTableView setFrame:tmpRect];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    CGRect tmpRect = self.view.bounds;
    tmpRect.origin.y = kNavBarHeight;
    tmpRect.size.height -= kNavBarHeight;
    [self.gTableView setFrame:tmpRect];
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
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

@end
