//
//  WVRProgramPackageController.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramPackageController.h"

#import "WVRProgramPackageViewModel.h"
#import "WVRProgramPackageModel.h"
#import "WVRUMShareView.h"

#import "WVRWidgetHeader.h"
#import "WVRComputeTool.h"

#import "WVRMediator+PayActions.h"
#import "WVRMediator+AccountActions.h"
#import "WVRSectionModel.h"

#import "WVRProgramPackagePresenter.h"

#define btnHeight (fitToWidth(45))

@interface WVRProgramPackageController ()

@property (nonatomic, strong) WVRSectionModel * gResultSectionModel;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) UIButton * gPayBtn;

//@property (nonatomic, strong) WVRSectionModel * responseModel;

@end


@implementation WVRProgramPackageController
@synthesize gPresenter = _gPresenter;

- (WVRManualArrangePresenter *)gPresenter {
    if (!_gPresenter) {
        _gPresenter = [[WVRProgramPackagePresenter alloc] initWithParams:self.createArgs attchView:self];
        _gPresenter.biDelegate = self;
    }
    return _gPresenter;
}

- (UIButton *)gPayBtn {
    if (!_gPayBtn) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [btn addTarget:self action:@selector(goShopping) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = kBoldFontFitSize(16.5);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = k_Color15;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(self.view.width);
        }];
        _gPayBtn = btn;
    }
    return _gPayBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.gCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.gPayBtn.mas_top);
        make.width.mas_equalTo(self.view.width);
    }];
    [[WVRMediator sharedInstance] WVRMediator_ReportLostInAppPurchaseOrders];
    self.isFirst = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotResponse) name:NAME_NOTF_MANUAL_ARRANGE_PROGRAMPACKAGE object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBuySuccessNoti object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.navigationController) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithBuySuccessNoti:) name:kBuySuccessNoti object:nil];
    }
}

// MARK: - Notification

- (void)refreshNotResponse {
    if (self.gPayBtn.superview) {
        [self removeShopBtn];
    }
    [(WVRProgramPackagePresenter *)self.gPresenter refresh];
}

- (void)dealWithBuySuccessNoti:(NSNotification *)noti {
    
    if (self.gResultSectionModel.haveCharged) { return; }
    NSString *coupon = noti.userInfo[@"goodsCode"];
    
    if ([coupon isEqualToString:self.gResultSectionModel.packModel.couponDto.code]) {
        
        self.gResultSectionModel.haveCharged = YES;
        [self removeShopBtn];
    }
}

// MARK: - UI

- (void)updatePayStatus:(WVRSectionModel *)args {
    self.gResultSectionModel = args;
    
    if (!args.haveCharged) {
        [self createPayBtn];
    }
}

- (void)createPayBtn {
    
    NSString *price = [WVRComputeTool numToPriceNumber:self.gResultSectionModel.price];
    
    NSString *title = [NSString stringWithFormat:@"购买节目包观看券 ¥%@", price];
    if ([self.gResultSectionModel.packModel packageType] == WVRPackageTypeProgramSet) {
        title = [NSString stringWithFormat:@"购买合集观看券 ¥%@", price];
    }
    [self.gPayBtn setTitle:title forState:UIControlStateNormal];
    [self.gPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(btnHeight);
    }];
}

- (void)goShopping {
    if (![self checkLogin]) {
        return;
    }
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSInteger payResult = [input[@"success"] integerValue];
            BOOL success = (payResult == 1);
            
            @strongify(self);
            if(success){
                [self removeShopBtn];
                [(WVRProgramPackagePresenter *)self.gPresenter refresh];
                if (self.prePayResultBlock) {
                    self.prePayResultBlock();
                    self.prePayResultBlock = nil;
                }
            }

            return nil;
        }];
    }];
    
    //    @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"streamType"] = @(0);
    dict[@"itemModel"] = self.gResultSectionModel.packModel;
    dict[@"cmd"] = cmd;
    
    [[WVRMediator sharedInstance] WVRMediator_PayForVideo:dict];
}

- (BOOL)checkLogin
{
    return [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil];
}

- (void)removeShopBtn {
    
    [self.gPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (WVRShareType)shareType
{
    return WVRShareTypeSpecialProgramPackage;
}

#pragma mark - BI

/// 对应BI埋点的pageId字段，直播预告页面已重写该方法
- (NSString *)currentPageId {
    
    if ([self.gPresenter isProgramSet]) {
        return @"programSet";
    }
    return @"programPackage";
}

@end
